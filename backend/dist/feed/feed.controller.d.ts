import { User } from '../users/entities/user.entity';
import { FeedService } from './feed.service';
export declare class FeedController {
    private readonly feedService;
    constructor(feedService: FeedService);
    discover(user: User, category?: string, search?: string, sort?: string, page?: string, limit?: string): Promise<{
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
