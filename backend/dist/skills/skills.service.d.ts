import { Repository } from 'typeorm';
import { Skill } from './entities/skill.entity';
import { UserSkill } from './entities/user-skill.entity';
import { UserLearningGoal } from './entities/user-learning-goal.entity';
import { User } from '../users/entities/user.entity';
import { CreateSkillDto } from './dto/create-skill.dto';
import { AddUserSkillDto } from './dto/add-user-skill.dto';
import { AddLearningGoalDto } from './dto/add-learning-goal.dto';
export declare class SkillsService {
    private readonly skillRepo;
    private readonly userSkillRepo;
    private readonly goalRepo;
    private readonly userRepo;
    constructor(skillRepo: Repository<Skill>, userSkillRepo: Repository<UserSkill>, goalRepo: Repository<UserLearningGoal>, userRepo: Repository<User>);
    findAll(query?: {
        category?: string;
        search?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        skills: Skill[];
        categories: string[];
        total: number;
        page: number;
        totalPages: number;
    }>;
    create(dto: CreateSkillDto): Promise<Skill>;
    getUserSkills(userId: string): Promise<{
        skills: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            proficiency: number;
        }[];
    }>;
    addUserSkill(userId: string, dto: AddUserSkillDto): Promise<{
        id: string;
        skillId: string;
        name: string;
        category: string;
        proficiency: number;
    }>;
    removeUserSkill(userId: string, id: string): Promise<{
        message: string;
    }>;
    getLearningGoals(userId: string): Promise<{
        goals: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            priority: number;
        }[];
    }>;
    addLearningGoal(userId: string, dto: AddLearningGoalDto): Promise<{
        id: string;
        skillId: string;
        name: string;
        category: string;
        priority: number;
    }>;
    removeLearningGoal(userId: string, id: string): Promise<{
        message: string;
    }>;
}
