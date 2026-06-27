import { Injectable, ForbiddenException, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like } from 'typeorm';
import { Skill } from './entities/skill.entity';
import { UserSkill } from './entities/user-skill.entity';
import { UserLearningGoal } from './entities/user-learning-goal.entity';
import { User } from '../users/entities/user.entity';
import { CreateSkillDto } from './dto/create-skill.dto';
import { AddUserSkillDto } from './dto/add-user-skill.dto';
import { AddLearningGoalDto } from './dto/add-learning-goal.dto';

@Injectable()
export class SkillsService {
  constructor(
    @InjectRepository(Skill)
    private readonly skillRepo: Repository<Skill>,
    @InjectRepository(UserSkill)
    private readonly userSkillRepo: Repository<UserSkill>,
    @InjectRepository(UserLearningGoal)
    private readonly goalRepo: Repository<UserLearningGoal>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async findAll(query?: { category?: string; search?: string; page?: number; limit?: number }) {
    const page = query?.page || 1;
    const limit = query?.limit || 20;
    const where: any = {};

    if (query?.category && query.category !== 'All') {
      where.category = query.category;
    }

    if (query?.search) {
      where.name = Like(`%${query.search}%`);
    }

    const [skills, total] = await this.skillRepo.findAndCount({
      where,
      skip: (page - 1) * limit,
      take: limit,
      order: { name: 'ASC' },
    });

    return {
      skills,
      categories: ['All', 'Design', 'Coding', 'Language', 'Music', 'Art'],
      total,
      page,
      totalPages: Math.ceil(total / limit),
    };
  }

  async create(dto: CreateSkillDto) {
    const existing = await this.skillRepo.findOne({ where: { name: dto.name } });
    if (existing) {
      throw new ConflictException(`Skill "${dto.name}" already exists`);
    }
    const skill = this.skillRepo.create({ ...dto, isUserCreated: true });
    return this.skillRepo.save(skill);
  }

  async getUserSkills(userId: string) {
    const userSkills = await this.userSkillRepo.find({
      where: { userId },
      relations: { skill: true },
      order: { createdAt: 'DESC' },
    });
    return {
      skills: userSkills.map((us) => ({
        id: us.id,
        skillId: us.skillId,
        name: us.skill.name,
        category: us.skill.category,
        proficiency: us.proficiency,
      })),
    };
  }

  async addUserSkill(userId: string, dto: AddUserSkillDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (!user.isPremium) {
      const count = await this.userSkillRepo.count({ where: { userId } });
      if (count >= 3) {
        throw new ForbiddenException('Free users can add up to 3 skills. Upgrade to Premium for unlimited skills.');
      }
    }

    const skill = await this.skillRepo.findOne({ where: { id: dto.skillId } });
    if (!skill) throw new NotFoundException('Skill not found');

    const existing = await this.userSkillRepo.findOne({ where: { userId, skillId: dto.skillId } });
    if (existing) throw new ConflictException('You already have this skill');

    const userSkill = this.userSkillRepo.create({
      userId,
      skillId: dto.skillId,
      proficiency: dto.proficiency,
    });
    const saved = await this.userSkillRepo.save(userSkill);
    return { id: saved.id, skillId: saved.skillId, name: skill.name, category: skill.category, proficiency: saved.proficiency };
  }

  async removeUserSkill(userId: string, id: string) {
    const userSkill = await this.userSkillRepo.findOne({ where: { id, userId } });
    if (!userSkill) throw new NotFoundException('Skill not found in your profile');
    await this.userSkillRepo.remove(userSkill);
    return { message: 'Skill removed' };
  }

  async getLearningGoals(userId: string) {
    const goals = await this.goalRepo.find({
      where: { userId },
      relations: { skill: true },
      order: { createdAt: 'DESC' },
    });
    return {
      goals: goals.map((g) => ({
        id: g.id,
        skillId: g.skillId,
        name: g.skill.name,
        category: g.skill.category,
        priority: g.priority,
      })),
    };
  }

  async addLearningGoal(userId: string, dto: AddLearningGoalDto) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (!user.isPremium) {
      const count = await this.goalRepo.count({ where: { userId } });
      if (count >= 3) {
        throw new ForbiddenException('Free users can add up to 3 learning goals. Upgrade to Premium for unlimited goals.');
      }
    }

    const skill = await this.skillRepo.findOne({ where: { id: dto.skillId } });
    if (!skill) throw new NotFoundException('Skill not found');

    const existing = await this.goalRepo.findOne({ where: { userId, skillId: dto.skillId } });
    if (existing) throw new ConflictException('You already want to learn this skill');

    const goal = this.goalRepo.create({ userId, skillId: dto.skillId, priority: dto.priority });
    const saved = await this.goalRepo.save(goal);
    return { id: saved.id, skillId: saved.skillId, name: skill.name, category: skill.category, priority: saved.priority };
  }

  async removeLearningGoal(userId: string, id: string) {
    const goal = await this.goalRepo.findOne({ where: { id, userId } });
    if (!goal) throw new NotFoundException('Learning goal not found');
    await this.goalRepo.remove(goal);
    return { message: 'Learning goal removed' };
  }
}
