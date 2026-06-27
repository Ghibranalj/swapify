import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Skill } from '../skills/entities/skill.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { Certificate } from '../certificates/entities/certificate.entity';
export declare class FeedService {
    private userRepo;
    private userSkillRepo;
    private goalRepo;
    private skillRepo;
    private swapRepo;
    private certRepo;
    constructor(userRepo: Repository<User>, userSkillRepo: Repository<UserSkill>, goalRepo: Repository<UserLearningGoal>, skillRepo: Repository<Skill>, swapRepo: Repository<SwapRequest>, certRepo: Repository<Certificate>);
    discover(userId: string, query: {
        category?: string;
        search?: string;
        sort?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        users: {
            id: string;
            name: string;
            bio: string;
            profileImageUrl: string;
            imageAsset: string;
            rating: string;
            swaps: string;
            isPremium: boolean;
            categories: string[];
            skills: string[];
            learningGoals: string[];
            certificates: string[];
            matchScore: number;
        }[];
        page: number;
        totalPages: number;
        total: number;
    }>;
}
