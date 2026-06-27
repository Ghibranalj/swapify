import { User } from '../../users/entities/user.entity';
export declare class Notification {
    id: string;
    userId: string;
    type: string;
    title: string;
    referenceId: string | null;
    isRead: boolean;
    createdAt: Date;
    user: User;
}
