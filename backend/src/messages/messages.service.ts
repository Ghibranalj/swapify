import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message } from './entities/message.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { User } from '../users/entities/user.entity';
import { Notification } from '../notifications/entities/notification.entity';

@Injectable()
export class MessagesService {
  constructor(
    @InjectRepository(Message) private msgRepo: Repository<Message>,
    @InjectRepository(SwapRequest) private swapRepo: Repository<SwapRequest>,
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Notification) private notifRepo: Repository<Notification>,
  ) {}

  async getThreads(userId: string) {
    const swaps = await this.swapRepo.createQueryBuilder('sr')
      .leftJoinAndSelect('sr.requester', 'requester')
      .leftJoinAndSelect('sr.provider', 'provider')
      .where('(sr.requesterId = :userId OR sr.providerId = :userId)', { userId })
      .andWhere('sr.status IN (:...statuses)', { statuses: ['active', 'done'] })
      .orderBy('sr.updatedAt', 'DESC')
      .getMany();

    const threads = [];
    for (const swap of swaps) {
      const other = swap.requesterId === userId ? swap.provider : swap.requester;
      const lastMsg = await this.msgRepo.findOne({ where: { swapRequestId: swap.id }, order: { createdAt: 'DESC' } });
      const unread = await this.msgRepo.count({ where: { swapRequestId: swap.id, senderId: other.id, isRead: false } });

      threads.push({
        id: swap.id,
        name: other.name,
        lastMessage: lastMsg?.content || 'No messages yet',
        time: lastMsg ? this.getRelativeTime(lastMsg.createdAt) : '',
        image: other.profileImageUrl || '',
        unreadCount: unread.toString(),
        isOnline: false,
      });
    }
    return { threads };
  }

  async getMessages(swapRequestId: string, userId: string, query?: { before?: string; limit?: number }) {
    const swap = await this.swapRepo.findOne({ where: { id: swapRequestId } });
    if (!swap) throw new NotFoundException('Conversation not found');
    if (swap.requesterId !== userId && swap.providerId !== userId) throw new ForbiddenException();

    const limit = query?.limit || 50;
    const qb = this.msgRepo.createQueryBuilder('msg')
      .where('msg.swapRequestId = :swapRequestId', { swapRequestId })
      .orderBy('msg.createdAt', 'ASC')
      .take(limit);

    if (query?.before) {
      qb.andWhere('msg.createdAt < :before', { before: query.before });
    }

    const messages = await qb.getMany();
    return {
      messages: messages.map(m => ({ id: m.id, text: m.content, isSender: m.senderId === userId, createdAt: m.createdAt })),
      hasMore: messages.length === limit,
    };
  }

  async sendMessage(swapRequestId: string, senderId: string, dto: { content: string }) {
    const swap = await this.swapRepo.findOne({ where: { id: swapRequestId }, relations: { requester: true, provider: true } });
    if (!swap) throw new NotFoundException();
    if (swap.requesterId !== senderId && swap.providerId !== senderId) throw new ForbiddenException();

    const msg = this.msgRepo.create({ swapRequestId, senderId, content: dto.content });
    const saved = await this.msgRepo.save(msg);

    const sender = swap.requesterId === senderId ? swap.requester : swap.provider;
    const recipientId = swap.requesterId === senderId ? swap.providerId : swap.requesterId;
    await this.notifRepo.save(this.notifRepo.create({ userId: recipientId, type: 'new_message', title: `New message from ${sender.name}`, referenceId: swapRequestId }));

    return { id: saved.id, text: saved.content, isSender: true, createdAt: saved.createdAt };
  }

  async markAsRead(messageId: string, userId: string) {
    const msg = await this.msgRepo.findOne({ where: { id: messageId } });
    if (!msg) throw new NotFoundException();
    msg.isRead = true;
    await this.msgRepo.save(msg);
    return { id: msg.id, isRead: true };
  }

  async markAllThreadAsRead(swapRequestId: string, userId: string) {
    const swap = await this.swapRepo.findOne({ where: { id: swapRequestId } });
    if (!swap) throw new NotFoundException();
    const otherUserId = swap.requesterId === userId ? swap.providerId : swap.requesterId;
    const result = await this.msgRepo.update({ swapRequestId, senderId: otherUserId, isRead: false }, { isRead: true });
    return { updatedCount: result.affected || 0 };
  }

  private getRelativeTime(date: Date): string {
    const now = new Date();
    const diffMs = now.getTime() - new Date(date).getTime();
    const diffMins = Math.floor(diffMs / 60000);
    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    const diffHours = Math.floor(diffMins / 60);
    if (diffHours < 24) return `${diffHours}h ago`;
    const diffDays = Math.floor(diffHours / 24);
    return `${diffDays}d ago`;
  }
}
