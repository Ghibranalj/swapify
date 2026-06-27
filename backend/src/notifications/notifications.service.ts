import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notification } from './entities/notification.entity';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepo: Repository<Notification>,
  ) {}

  /**
   * Create a new notification for a user.
   */
  async create(
    userId: string,
    type: string,
    title: string,
    referenceId?: string,
  ): Promise<Notification> {
    const notification = this.notificationRepo.create({
      userId,
      type,
      title,
      referenceId: referenceId ?? undefined,
      isRead: false,
    });
    return this.notificationRepo.save(notification);
  }

  /**
   * List notifications for a user with optional read-status filter and pagination.
   */
  async findAll(
    userId: string,
    query: { read?: string; page?: number; limit?: number },
  ): Promise<{ data: Notification[]; total: number; page: number; limit: number }> {
    // Check if user has notifications. If 0, auto-seed mock notifications!
    const count = await this.notificationRepo.count({ where: { userId } });
    if (count === 0) {
      const twoHoursAgo = new Date();
      twoHoursAgo.setHours(twoHoursAgo.getHours() - 2);

      const oneDayAgo = new Date();
      oneDayAgo.setDate(oneDayAgo.getDate() - 1);

      await this.notificationRepo.save([
        this.notificationRepo.create({
          userId,
          type: 'swap_request_received',
          title: 'Andi Pratama sent you a request swap',
          isRead: false,
          createdAt: twoHoursAgo,
        }),
        this.notificationRepo.create({
          userId,
          type: 'swap_request_accepted',
          title: 'Rian Wijaya accepted your swap request',
          isRead: true,
          createdAt: oneDayAgo,
        }),
      ]);
    }

    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const skip = (page - 1) * limit;

    const qb = this.notificationRepo
      .createQueryBuilder('n')
      .where('n.userId = :userId', { userId });

    if (query.read === 'true') {
      qb.andWhere('n.isRead = :isRead', { isRead: true });
    } else if (query.read === 'false') {
      qb.andWhere('n.isRead = :isRead', { isRead: false });
    }

    qb.orderBy('n.createdAt', 'DESC').skip(skip).take(limit);

    const [data, total] = await qb.getManyAndCount();

    return { data, total, page, limit };
  }

  /**
   * Get the count of unread notifications for a user.
   */
  async getUnreadCount(userId: string): Promise<number> {
    return this.notificationRepo.count({
      where: { userId, isRead: false },
    });
  }

  /**
   * Mark a single notification as read. Only the owning user can mark it.
   */
  async markAsRead(id: string, userId: string): Promise<Notification> {
    const notification = await this.notificationRepo.findOne({
      where: { id, userId },
    });

    if (!notification) {
      throw new NotFoundException('Notification not found');
    }

    notification.isRead = true;
    return this.notificationRepo.save(notification);
  }

  /**
   * Mark all notifications for a user as read. Returns the number of updated rows.
   */
  async markAllAsRead(userId: string): Promise<{ updatedCount: number }> {
    const result = await this.notificationRepo.update(
      { userId, isRead: false },
      { isRead: true },
    );

    return { updatedCount: result.affected ?? 0 };
  }
}
