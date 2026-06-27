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
exports.NotificationsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const notification_entity_1 = require("./entities/notification.entity");
let NotificationsService = class NotificationsService {
    notificationRepo;
    constructor(notificationRepo) {
        this.notificationRepo = notificationRepo;
    }
    async create(userId, type, title, referenceId) {
        const notification = this.notificationRepo.create({
            userId,
            type,
            title,
            referenceId: referenceId ?? undefined,
            isRead: false,
        });
        return this.notificationRepo.save(notification);
    }
    async findAll(userId, query) {
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
        }
        else if (query.read === 'false') {
            qb.andWhere('n.isRead = :isRead', { isRead: false });
        }
        qb.orderBy('n.createdAt', 'DESC').skip(skip).take(limit);
        const [data, total] = await qb.getManyAndCount();
        return { data, total, page, limit };
    }
    async getUnreadCount(userId) {
        return this.notificationRepo.count({
            where: { userId, isRead: false },
        });
    }
    async markAsRead(id, userId) {
        const notification = await this.notificationRepo.findOne({
            where: { id, userId },
        });
        if (!notification) {
            throw new common_1.NotFoundException('Notification not found');
        }
        notification.isRead = true;
        return this.notificationRepo.save(notification);
    }
    async markAllAsRead(userId) {
        const result = await this.notificationRepo.update({ userId, isRead: false }, { isRead: true });
        return { updatedCount: result.affected ?? 0 };
    }
};
exports.NotificationsService = NotificationsService;
exports.NotificationsService = NotificationsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(notification_entity_1.Notification)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], NotificationsService);
//# sourceMappingURL=notifications.service.js.map