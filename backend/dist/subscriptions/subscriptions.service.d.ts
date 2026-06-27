import { Repository } from 'typeorm';
import { Subscription } from './entities/subscription.entity';
import { User } from '../users/entities/user.entity';
export declare class SubscriptionsService {
    private subRepo;
    private userRepo;
    constructor(subRepo: Repository<Subscription>, userRepo: Repository<User>);
    getPlans(): {
        plans: ({
            id: string;
            name: string;
            price: number;
            currency: string;
            interval: string;
            features: string[];
            savings?: undefined;
            badge?: undefined;
        } | {
            id: string;
            name: string;
            price: number;
            currency: string;
            interval: string;
            savings: number;
            badge: string;
            features: string[];
        })[];
    };
    subscribe(userId: string, dto: {
        planId: string;
        paymentMethod: string;
        paymentDetails?: any;
    }): Promise<{
        subscriptionId: string;
        status: string;
        plan: string;
        expiresAt: Date;
    }>;
    getMySubscription(userId: string): Promise<{
        subscription: null;
    } | {
        subscription: Subscription;
    }>;
    cancel(userId: string): Promise<{
        message: string;
    }>;
}
