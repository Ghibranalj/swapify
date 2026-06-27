import { Repository } from 'typeorm';
import { SwapRequest } from './entities/swap-request.entity';
import { User } from '../users/entities/user.entity';
import { Skill } from '../skills/entities/skill.entity';
import { Notification } from '../notifications/entities/notification.entity';
export declare class SwapRequestsService {
    private swapRepo;
    private userRepo;
    private skillRepo;
    private notifRepo;
    constructor(swapRepo: Repository<SwapRequest>, userRepo: Repository<User>, skillRepo: Repository<Skill>, notifRepo: Repository<Notification>);
    create(requesterId: string, dto: {
        providerId: string;
        requesterSkillId: string;
        providerSkillId: string;
        message?: string;
    }): Promise<{
        id: string;
        requesterId: string;
        providerId: string;
        name: string;
        date: string;
        skill1: string;
        skill2: string;
        message: string;
        tabType: string;
        status: string;
        rating: number | null;
        ratingComment: string | null;
        requester: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
        provider: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
    }>;
    findAll(userId: string, query: {
        status?: string;
        direction?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        requests: {
            id: string;
            requesterId: string;
            providerId: string;
            name: string;
            date: string;
            skill1: string;
            skill2: string;
            message: string;
            tabType: string;
            status: string;
            rating: number | null;
            ratingComment: string | null;
            requester: {
                id: string;
                name: string;
                profileImageUrl: string;
            };
            provider: {
                id: string;
                name: string;
                profileImageUrl: string;
            };
        }[];
        page: number;
        totalPages: number;
        total: number;
    }>;
    findOne(id: string, userId: string): Promise<{
        id: string;
        requesterId: string;
        providerId: string;
        name: string;
        date: string;
        skill1: string;
        skill2: string;
        message: string;
        tabType: string;
        status: string;
        rating: number | null;
        ratingComment: string | null;
        requester: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
        provider: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
    }>;
    accept(id: string, userId: string): Promise<{
        id: string;
        requesterId: string;
        providerId: string;
        name: string;
        date: string;
        skill1: string;
        skill2: string;
        message: string;
        tabType: string;
        status: string;
        rating: number | null;
        ratingComment: string | null;
        requester: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
        provider: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
    }>;
    decline(id: string, userId: string): Promise<{
        message: string;
    }>;
    cancel(id: string, userId: string): Promise<{
        message: string;
    }>;
    complete(id: string, userId: string): Promise<{
        id: string;
        requesterId: string;
        providerId: string;
        name: string;
        date: string;
        skill1: string;
        skill2: string;
        message: string;
        tabType: string;
        status: string;
        rating: number | null;
        ratingComment: string | null;
        requester: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
        provider: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
    }>;
    rate(id: string, userId: string, dto: {
        rating: number;
        comment?: string;
    }): Promise<{
        id: string;
        requesterId: string;
        providerId: string;
        name: string;
        date: string;
        skill1: string;
        skill2: string;
        message: string;
        tabType: string;
        status: string;
        rating: number | null;
        ratingComment: string | null;
        requester: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
        provider: {
            id: string;
            name: string;
            profileImageUrl: string;
        };
    }>;
}
