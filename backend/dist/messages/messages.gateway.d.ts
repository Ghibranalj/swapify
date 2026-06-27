import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MessagesService } from './messages.service';
export declare class MessagesGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private readonly messagesService;
    server: Server;
    private onlineUsers;
    constructor(messagesService: MessagesService);
    handleConnection(client: Socket): void;
    handleDisconnect(client: Socket): void;
    handleJoinRoom(client: Socket, swapRequestId: string): {
        event: string;
        data: string;
    };
    handleLeaveRoom(client: Socket, swapRequestId: string): void;
    handleSendMessage(client: Socket, data: {
        swapRequestId: string;
        content: string;
    }): Promise<{
        id: string;
        text: string;
        isSender: boolean;
        createdAt: Date;
    } | undefined>;
    handleTyping(client: Socket, swapRequestId: string): void;
}
