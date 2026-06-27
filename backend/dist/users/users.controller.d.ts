import { UsersService } from './users.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
export declare class UsersController {
    private readonly usersService;
    private readonly profileUploadDir;
    constructor(usersService: UsersService);
    getMyProfile(user: {
        id: string;
    }): Promise<{
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
    updateMyProfile(user: {
        id: string;
    }, dto: UpdateProfileDto): Promise<{
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
    uploadProfileImage(user: {
        id: string;
    }, file: Express.Multer.File): Promise<{
        profileImageUrl: string;
    }>;
    getPublicProfile(id: string): Promise<{
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
}
