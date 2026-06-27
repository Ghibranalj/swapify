import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Skill } from '../skills/entities/skill.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { Certificate } from '../certificates/entities/certificate.entity';

@Injectable()
export class FeedService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(UserSkill) private userSkillRepo: Repository<UserSkill>,
    @InjectRepository(UserLearningGoal) private goalRepo: Repository<UserLearningGoal>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(SwapRequest) private swapRepo: Repository<SwapRequest>,
    @InjectRepository(Certificate) private certRepo: Repository<Certificate>,
  ) {}

  async discover(userId: string, query: {
    category?: string; search?: string; sort?: string; page?: number; limit?: number;
  }) {
    const page = query.page || 1;
    const limit = query.limit || 20;

    // Get current user's learning goals and skills
    const myGoals = await this.goalRepo.find({ where: { userId }, relations: { skill: true } });
    const mySkills = await this.userSkillRepo.find({ where: { userId }, relations: { skill: true } });
    const myGoalSkillIds = myGoals.map(g => g.skillId);
    const mySkillIds = mySkills.map(s => s.skillId);

    // Get all other users
    let usersQuery = this.userRepo.createQueryBuilder('user')
      .where('user.id != :userId', { userId })
      .andWhere('user.status = :status', { status: 'active' });

    if (query.search) {
      usersQuery = usersQuery.andWhere('user.name LIKE :search', { search: `%${query.search}%` });
    }

    const allUsers = await usersQuery.getMany();

    // Score each user
    const scoredUsers = [];
    for (const user of allUsers) {
      const theirSkills = await this.userSkillRepo.find({ where: { userId: user.id }, relations: { skill: true } });
      const theirGoals = await this.goalRepo.find({ where: { userId: user.id }, relations: { skill: true } });
      const theirCerts = await this.certRepo.find({ where: { userId: user.id } });

      // Filter by category if provided
      if (query.category) {
        const hasCategory = theirSkills.some(s => s.skill.category === query.category);
        if (!hasCategory) continue;
      }

      // Calculate match score
      let matchScore = 0;
      const matchingSkills = [];

      for (const ts of theirSkills) {
        if (myGoalSkillIds.includes(ts.skillId)) {
          matchScore += 10;
          matchingSkills.push(ts.skill.name);
        }
      }

      for (const tg of theirGoals) {
        if (mySkillIds.includes(tg.skillId)) {
          matchScore += 5; // Mutual benefit
        }
      }

      if (user.isPremium) matchScore += 15;

      // Compute average rating
      const ratings = await this.swapRepo
        .createQueryBuilder('sr')
        .where('(sr.requesterId = :uid OR sr.providerId = :uid)', { uid: user.id })
        .andWhere('sr.rating IS NOT NULL')
        .select('AVG(sr.rating)', 'avg')
        .addSelect('COUNT(sr.rating)', 'count')
        .getRawOne();

      const avgRating = ratings?.avg ? parseFloat(parseFloat(ratings.avg).toFixed(1)) : 0;
      const categories = [...new Set(theirSkills.map(s => s.skill.category))];

      // Sort skills so that skills belonging to query.category are at the beginning
      const sortedSkills = [...theirSkills].sort((a, b) => {
        if (query.category) {
          const aMatch = a.skill.category === query.category ? 1 : 0;
          const bMatch = b.skill.category === query.category ? 1 : 0;
          return bMatch - aMatch;
        }
        return 0;
      });

      scoredUsers.push({
        id: user.id,
        name: user.name,
        bio: user.bio || '',
        profileImageUrl: user.profileImageUrl || '',
        imageAsset: user.profileImageUrl || '',
        rating: avgRating.toString(),
        swaps: user.swapCount.toString(),
        isPremium: user.isPremium,
        categories,
        skills: sortedSkills.map(s => s.skill.name),
        learningGoals: theirGoals.map(g => g.skill.name),
        certificates: theirCerts.map(c => c.fileUrl),
        matchScore,
      });
    }

    // Sort
    switch (query.sort) {
      case 'rating':
        scoredUsers.sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating));
        break;
      case 'newest':
        scoredUsers.sort((a, b) => 0); // already in DB order
        break;
      default: // relevance
        scoredUsers.sort((a, b) => b.matchScore - a.matchScore);
    }

    // Paginate
    const total = scoredUsers.length;
    const paginated = scoredUsers.slice((page - 1) * limit, page * limit);

    return {
      users: paginated,
      page,
      totalPages: Math.ceil(total / limit),
      total,
    };
  }
}
