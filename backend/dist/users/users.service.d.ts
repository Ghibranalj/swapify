import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Certificate } from '../certificates/entities/certificate.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UsersService {
    private readonly userRepo;
    private readonly userSkillRepo;
    private readonly learningGoalRepo;
    private readonly certificateRepo;
    private readonly swapRequestRepo;
    constructor(userRepo: Repository<User>, userSkillRepo: Repository<UserSkill>, learningGoalRepo: Repository<UserLearningGoal>, certificateRepo: Repository<Certificate>, swapRequestRepo: Repository<SwapRequest>);
    private computeRating;
    getProfile(userId: string): Promise<{
        id: string;
        name: string;
        email: string;
        bio: string;
        profileImageUrl: string;
        isPremium: boolean;
        premiumExpiresAt: Date | null;
        swapCount: number;
        status: string;
        isAdmin: boolean;
        createdAt: Date;
        updatedAt: Date;
        averageRating: number;
        totalRatings: number;
        skills: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            proficiency: number;
            createdAt: Date;
        }[];
        learningGoals: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            priority: number;
            createdAt: Date;
        }[];
        certificates: {
            id: string;
            title: string;
            fileUrl: string;
            fileName: string;
            fileType: string;
            fileSize: number;
            skillId: string | null;
            skillName: string;
            createdAt: Date;
        }[];
    }>;
    updateProfile(userId: string, dto: UpdateProfileDto): Promise<{
        id: string;
        name: string;
        email: string;
        bio: string;
        profileImageUrl: string;
        isPremium: boolean;
        premiumExpiresAt: Date | null;
        swapCount: number;
        status: string;
        isAdmin: boolean;
        createdAt: Date;
        updatedAt: Date;
        averageRating: number;
        totalRatings: number;
        skills: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            proficiency: number;
            createdAt: Date;
        }[];
        learningGoals: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            priority: number;
            createdAt: Date;
        }[];
        certificates: {
            id: string;
            title: string;
            fileUrl: string;
            fileName: string;
            fileType: string;
            fileSize: number;
            skillId: string | null;
            skillName: string;
            createdAt: Date;
        }[];
    }>;
    getPublicProfile(userId: string): Promise<{
        id: string;
        name: string;
        bio: string;
        profileImageUrl: string;
        isPremium: boolean;
        swapCount: number;
        createdAt: Date;
        averageRating: number;
        totalRatings: number;
        skills: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            proficiency: number;
        }[];
        learningGoals: {
            id: string;
            skillId: string;
            name: string;
            category: string;
            priority: number;
        }[];
        certificates: {
            id: string;
            title: string;
            fileUrl: string;
            fileType: string;
            skillId: string | null;
            skillName: string;
            createdAt: Date;
        }[];
    }>;
    uploadProfileImage(userId: string, fileUrl: string): Promise<{
        profileImageUrl: string;
    }>;
}
