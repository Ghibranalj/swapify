import { User } from '../../users/entities/user.entity';
export declare class Subscription {
    id: string;
    userId: string;
    plan: string;
    price: number;
    paymentMethod: string;
    status: string;
    startsAt: Date;
    expiresAt: Date;
    createdAt: Date;
    user: User;
}
