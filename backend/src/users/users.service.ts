import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Certificate } from '../certificates/entities/certificate.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    @InjectRepository(UserSkill)
    private readonly userSkillRepo: Repository<UserSkill>,
    @InjectRepository(UserLearningGoal)
    private readonly learningGoalRepo: Repository<UserLearningGoal>,
    @InjectRepository(Certificate)
    private readonly certificateRepo: Repository<Certificate>,
    @InjectRepository(SwapRequest)
    private readonly swapRequestRepo: Repository<SwapRequest>,
  ) {}

  /**
   * Computes the average rating for a user across all swap requests
   * where the user participated (as requester or provider) and a rating was given.
   */
  private async computeRating(userId: string): Promise<{ averageRating: number; totalRatings: number }> {
    const result = await this.swapRequestRepo
      .createQueryBuilder('sr')
      .select('AVG(sr.rating)', 'avg')
      .addSelect('COUNT(sr.rating)', 'count')
      .where('(sr.requesterId = :userId OR sr.providerId = :userId)', { userId })
      .andWhere('sr.rating IS NOT NULL')
      .getRawOne();

    return {
      averageRating: result?.avg ? parseFloat(Number(result.avg).toFixed(2)) : 0,
      totalRatings: result?.count ? parseInt(result.count, 10) : 0,
    };
  }

  /**
   * Returns the full profile for the authenticated user, including
   * skills (with skill name/category), learning goals, certificates, and rating info.
   */
  async getProfile(userId: string) {
    const user = await this.userRepo.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const skills = await this.userSkillRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const learningGoals = await this.learningGoalRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const certificates = await this.certificateRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const { averageRating, totalRatings } = await this.computeRating(userId);

    return {
      id: user.id,
      name: user.name,
      email: user.email,
      bio: user.bio,
      profileImageUrl: user.profileImageUrl,
      isPremium: user.isPremium,
      premiumExpiresAt: user.premiumExpiresAt,
      swapCount: user.swapCount,
      status: user.status,
      isAdmin: user.isAdmin,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      averageRating,
      totalRatings,
      skills: skills.map((us) => ({
        id: us.id,
        skillId: us.skillId,
        name: us.skill?.name ?? '',
        category: us.skill?.category ?? '',
        proficiency: us.proficiency,
        createdAt: us.createdAt,
      })),
      learningGoals: learningGoals.map((lg) => ({
        id: lg.id,
        skillId: lg.skillId,
        name: lg.skill?.name ?? '',
        category: lg.skill?.category ?? '',
        priority: lg.priority,
        createdAt: lg.createdAt,
      })),
      certificates: certificates.map((c) => ({
        id: c.id,
        title: c.title,
        fileUrl: c.fileUrl,
        fileName: c.fileName,
        fileType: c.fileType,
        fileSize: c.fileSize,
        skillId: c.skillId,
        skillName: c.skill?.name ?? null,
        createdAt: c.createdAt,
      })),
    };
  }

  /**
   * Updates the authenticated user's name and/or bio.
   */
  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (dto.name !== undefined) {
      user.name = dto.name;
    }
    if (dto.bio !== undefined) {
      user.bio = dto.bio;
    }

    await this.userRepo.save(user);
    return this.getProfile(userId);
  }

  /**
   * Returns a public-facing profile for a given user ID.
   * Omits sensitive fields like refreshToken.
   */
  async getPublicProfile(userId: string) {
    const user = await this.userRepo.findOne({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const skills = await this.userSkillRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const learningGoals = await this.learningGoalRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const certificates = await this.certificateRepo.find({
      where: { userId },
      relations: { skill: true },
    });

    const { averageRating, totalRatings } = await this.computeRating(userId);

    return {
      id: user.id,
      name: user.name,
      bio: user.bio,
      profileImageUrl: user.profileImageUrl,
      isPremium: user.isPremium,
      swapCount: user.swapCount,
      createdAt: user.createdAt,
      averageRating,
      totalRatings,
      skills: skills.map((us) => ({
        id: us.id,
        skillId: us.skillId,
        name: us.skill?.name ?? '',
        category: us.skill?.category ?? '',
        proficiency: us.proficiency,
      })),
      learningGoals: learningGoals.map((lg) => ({
        id: lg.id,
        skillId: lg.skillId,
        name: lg.skill?.name ?? '',
        category: lg.skill?.category ?? '',
        priority: lg.priority,
      })),
      certificates: certificates.map((c) => ({
        id: c.id,
        title: c.title,
        fileUrl: c.fileUrl,
        fileType: c.fileType,
        skillId: c.skillId,
        skillName: c.skill?.name ?? null,
        createdAt: c.createdAt,
      })),
    };
  }

  /**
   * Updates the user's profile image URL.
   */
  async uploadProfileImage(userId: string, fileUrl: string) {
    const user = await this.userRepo.findOne({ where: { id: userId } });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    user.profileImageUrl = fileUrl;
    await this.userRepo.save(user);

    return { profileImageUrl: user.profileImageUrl };
  }
}
