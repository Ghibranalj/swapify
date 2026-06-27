"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MessagesService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const message_entity_1 = require("./entities/message.entity");
const swap_request_entity_1 = require("../swap-requests/entities/swap-request.entity");
const user_entity_1 = require("../users/entities/user.entity");
const notification_entity_1 = require("../notifications/entities/notification.entity");
let MessagesService = class MessagesService {
    msgRepo;
    swapRepo;
    userRepo;
    notifRepo;
    constructor(msgRepo, swapRepo, userRepo, notifRepo) {
        this.msgRepo = msgRepo;
        this.swapRepo = swapRepo;
        this.userRepo = userRepo;
        this.notifRepo = notifRepo;
    }
    async getThreads(userId) {
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
    async getMessages(swapRequestId, userId, query) {
        const swap = await this.swapRepo.findOne({ where: { id: swapRequestId } });
        if (!swap)
            throw new common_1.NotFoundException('Conversation not found');
        if (swap.requesterId !== userId && swap.providerId !== userId)
            throw new common_1.ForbiddenException();
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
    async sendMessage(swapRequestId, senderId, dto) {
        const swap = await this.swapRepo.findOne({ where: { id: swapRequestId }, relations: { requester: true, provider: true } });
        if (!swap)
            throw new common_1.NotFoundException();
        if (swap.requesterId !== senderId && swap.providerId !== senderId)
            throw new common_1.ForbiddenException();
        const msg = this.msgRepo.create({ swapRequestId, senderId, content: dto.content });
        const saved = await this.msgRepo.save(msg);
        const sender = swap.requesterId === senderId ? swap.requester : swap.provider;
        const recipientId = swap.requesterId === senderId ? swap.providerId : swap.requesterId;
        await this.notifRepo.save(this.notifRepo.create({ userId: recipientId, type: 'new_message', title: `New message from ${sender.name}`, referenceId: swapRequestId }));
        return { id: saved.id, text: saved.content, isSender: true, createdAt: saved.createdAt };
    }
    async markAsRead(messageId, userId) {
        const msg = await this.msgRepo.findOne({ where: { id: messageId } });
        if (!msg)
            throw new common_1.NotFoundException();
        msg.isRead = true;
        await this.msgRepo.save(msg);
        return { id: msg.id, isRead: true };
    }
    async markAllThreadAsRead(swapRequestId, userId) {
        const swap = await this.swapRepo.findOne({ where: { id: swapRequestId } });
        if (!swap)
            throw new common_1.NotFoundException();
        const otherUserId = swap.requesterId === userId ? swap.providerId : swap.requesterId;
        const result = await this.msgRepo.update({ swapRequestId, senderId: otherUserId, isRead: false }, { isRead: true });
        return { updatedCount: result.affected || 0 };
    }
    getRelativeTime(date) {
        const now = new Date();
        const diffMs = now.getTime() - new Date(date).getTime();
        const diffMins = Math.floor(diffMs / 60000);
        if (diffMins < 1)
            return 'Just now';
        if (diffMins < 60)
            return `${diffMins}m ago`;
        const diffHours = Math.floor(diffMins / 60);
        if (diffHours < 24)
            return `${diffHours}h ago`;
        const diffDays = Math.floor(diffHours / 24);
        return `${diffDays}d ago`;
    }
};
exports.MessagesService = MessagesService;
exports.MessagesService = MessagesService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(message_entity_1.Message)),
    __param(1, (0, typeorm_1.InjectRepository)(swap_request_entity_1.SwapRequest)),
    __param(2, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(3, (0, typeorm_1.InjectRepository)(notification_entity_1.Notification)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], MessagesService);
//# sourceMappingURL=messages.service.js.map