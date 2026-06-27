import { WebSocketGateway, WebSocketServer, SubscribeMessage, OnGatewayConnection, OnGatewayDisconnect, ConnectedSocket, MessageBody } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MessagesService } from './messages.service';

@WebSocketGateway({ cors: { origin: '*' }, namespace: '/chat' })
export class MessagesGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;
  private onlineUsers = new Map<string, string>();

  constructor(private readonly messagesService: MessagesService) {}

  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    if (userId) { this.onlineUsers.set(client.id, userId); }
  }

  handleDisconnect(client: Socket) { this.onlineUsers.delete(client.id); }

  @SubscribeMessage('joinRoom')
  handleJoinRoom(@ConnectedSocket() client: Socket, @MessageBody() swapRequestId: string) {
    client.join(swapRequestId);
    return { event: 'joinedRoom', data: swapRequestId };
  }

  @SubscribeMessage('leaveRoom')
  handleLeaveRoom(@ConnectedSocket() client: Socket, @MessageBody() swapRequestId: string) {
    client.leave(swapRequestId);
  }

  @SubscribeMessage('sendMessage')
  async handleSendMessage(@ConnectedSocket() client: Socket, @MessageBody() data: { swapRequestId: string; content: string }) {
    const userId = this.onlineUsers.get(client.id);
    if (!userId) return;
    const message = await this.messagesService.sendMessage(data.swapRequestId, userId, { content: data.content });
    this.server.to(data.swapRequestId).emit('newMessage', message);
    return message;
  }

  @SubscribeMessage('typing')
  handleTyping(@ConnectedSocket() client: Socket, @MessageBody() swapRequestId: string) {
    const userId = this.onlineUsers.get(client.id);
    client.to(swapRequestId).emit('userTyping', { userId });
  }
}
