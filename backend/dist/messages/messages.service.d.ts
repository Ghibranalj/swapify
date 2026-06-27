import { Repository } from 'typeorm';
import { Message } from './entities/message.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { User } from '../users/entities/user.entity';
import { Notification } from '../notifications/entities/notification.entity';
export declare class MessagesService {
    private msgRepo;
    private swapRepo;
    private userRepo;
    private notifRepo;
    constructor(msgRepo: Repository<Message>, swapRepo: Repository<SwapRequest>, userRepo: Repository<User>, notifRepo: Repository<Notification>);
    getThreads(userId: string): Promise<{
        threads: {
            id: string;
            name: string;
            lastMessage: string;
            time: string;
            image: string;
            unreadCount: string;
            isOnline: boolean;
        }[];
    }>;
    getMessages(swapRequestId: string, userId: string, query?: {
        before?: string;
        limit?: number;
    }): Promise<{
        messages: {
            id: string;
            text: string;
            isSender: boolean;
            createdAt: Date;
        }[];
        hasMore: boolean;
    }>;
    sendMessage(swapRequestId: string, senderId: string, dto: {
        content: string;
    }): Promise<{
        id: string;
        text: string;
        isSender: boolean;
        createdAt: Date;
    }>;
    markAsRead(messageId: string, userId: string): Promise<{
        id: string;
        isRead: boolean;
    }>;
    markAllThreadAsRead(swapRequestId: string, userId: string): Promise<{
        updatedCount: number;
    }>;
    private getRelativeTime;
}
