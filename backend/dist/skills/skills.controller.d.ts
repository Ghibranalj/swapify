import { User } from '../users/entities/user.entity';
import { SkillsService } from './skills.service';
import { CreateSkillDto } from './dto/create-skill.dto';
import { AddUserSkillDto } from './dto/add-user-skill.dto';
import { AddLearningGoalDto } from './dto/add-learning-goal.dto';
export declare class SkillsController {
    private readonly skillsService;
    constructor(skillsService: SkillsService);
    findAll(category?: string, search?: string, page?: string, limit?: string): Promise<{
        skills: import("./entities/skill.entity").Skill[];
        categories: string[];
        total: number;
        page: number;
        totalPages: number;
    }>;
    create(dto: CreateSkillDto): Promise<import("./entities/skill.entity").Skill>;
    getUserSkills(user: User): Promise<{
        skills: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            proficiency: number;
        }[];
    }>;
    addUserSkill(user: User, dto: AddUserSkillDto): Promise<{
        id: string;
        skillId: string;
        name: string;
        category: string;
        proficiency: number;
    }>;
    removeUserSkill(user: User, id: string): Promise<{
        message: string;
    }>;
    getLearningGoals(user: User): Promise<{
        goals: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            priority: number;
        }[];
    }>;
    addLearningGoal(user: User, dto: AddLearningGoalDto): Promise<{
        id: string;
        skillId: string;
        name: string;
        category: string;
        priority: number;
    }>;
    removeLearningGoal(user: User, id: string): Promise<{
        message: string;
    }>;
}
