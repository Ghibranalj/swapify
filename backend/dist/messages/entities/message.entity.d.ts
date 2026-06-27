import { SwapRequest } from '../../swap-requests/entities/swap-request.entity';
import { User } from '../../users/entities/user.entity';
export declare class Message {
    id: string;
    swapRequestId: string;
    senderId: string;
    content: string;
    isRead: boolean;
    createdAt: Date;
    swapRequest: SwapRequest;
    sender: User;
}
