import { User } from '../users/entities/user.entity';
import { SwapRequestsService } from './swap-requests.service';
import { CreateSwapRequestDto } from './dto/create-swap-request.dto';
import { RateSwapDto } from './dto/rate-swap.dto';
export declare class SwapRequestsController {
    private readonly swapService;
    constructor(swapService: SwapRequestsService);
    create(user: User, dto: CreateSwapRequestDto): Promise<{
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
    findAll(user: User, status?: string, direction?: string, page?: string, limit?: string): Promise<{
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
    findOne(user: User, id: string): Promise<{
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
    accept(user: User, id: string): Promise<{
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
    decline(user: User, id: string): Promise<{
        message: string;
    }>;
    cancel(user: User, id: string): Promise<{
        message: string;
    }>;
    complete(user: User, id: string): Promise<{
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
    rate(user: User, id: string, dto: RateSwapDto): Promise<{
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
