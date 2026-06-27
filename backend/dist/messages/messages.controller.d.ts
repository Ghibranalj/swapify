import { User } from '../users/entities/user.entity';
import { MessagesService } from './messages.service';
import { SendMessageDto } from './dto/send-message.dto';
export declare class MessagesController {
    private readonly messagesService;
    constructor(messagesService: MessagesService);
    getThreads(user: User): Promise<{
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
    getMessages(user: User, swapRequestId: string, before?: string, limit?: string): Promise<{
        messages: {
            id: string;
            text: string;
            isSender: boolean;
            createdAt: Date;
        }[];
        hasMore: boolean;
    }>;
    sendMessage(user: User, swapRequestId: string, dto: SendMessageDto): Promise<{
        id: string;
        text: string;
        isSender: boolean;
        createdAt: Date;
    }>;
    markAsRead(user: User, id: string): Promise<{
        id: string;
        isRead: boolean;
    }>;
    markAllRead(user: User, swapRequestId: string): Promise<{
        updatedCount: number;
    }>;
}
