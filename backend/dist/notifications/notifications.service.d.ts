import { Repository } from 'typeorm';
import { Notification } from './entities/notification.entity';
export declare class NotificationsService {
    private readonly notificationRepo;
    constructor(notificationRepo: Repository<Notification>);
    create(userId: string, type: string, title: string, referenceId?: string): Promise<Notification>;
    findAll(userId: string, query: {
        read?: string;
        page?: number;
        limit?: number;
    }): Promise<{
        data: Notification[];
        total: number;
        page: number;
        limit: number;
    }>;
    getUnreadCount(userId: string): Promise<number>;
    markAsRead(id: string, userId: string): Promise<Notification>;
    markAllAsRead(userId: string): Promise<{
        updatedCount: number;
    }>;
}
