import { User } from '../users/entities/user.entity';
import { SubscriptionsService } from './subscriptions.service';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';
export declare class SubscriptionsController {
    private readonly subsService;
    constructor(subsService: SubscriptionsService);
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
    subscribe(user: User, dto: CreateSubscriptionDto): Promise<{
        subscriptionId: string;
        status: string;
        plan: string;
        expiresAt: Date;
    }>;
    getMySubscription(user: User): Promise<{
        subscription: null;
    } | {
        subscription: import("./entities/subscription.entity").Subscription;
    }>;
    cancel(user: User): Promise<{
        message: string;
    }>;
}
