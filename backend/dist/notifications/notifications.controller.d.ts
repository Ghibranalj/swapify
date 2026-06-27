import { User } from '../users/entities/user.entity';
import { NotificationsService } from './notifications.service';
export declare class NotificationsController {
    private readonly notificationsService;
    constructor(notificationsService: NotificationsService);
    findAll(user: User, read?: string, page?: string, limit?: string): Promise<{
        data: import("./entities/notification.entity").Notification[];
        total: number;
        page: number;
        limit: number;
    }>;
    getUnreadCount(user: User): Promise<{
        count: number;
    }>;
    markAsRead(user: User, id: string): Promise<import("./entities/notification.entity").Notification>;
    markAllAsRead(user: User): Promise<{
        updatedCount: number;
    }>;
}
