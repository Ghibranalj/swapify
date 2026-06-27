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
exports.SwapRequestsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const swap_request_entity_1 = require("./entities/swap-request.entity");
const user_entity_1 = require("../users/entities/user.entity");
const skill_entity_1 = require("../skills/entities/skill.entity");
const notification_entity_1 = require("../notifications/entities/notification.entity");
let SwapRequestsService = class SwapRequestsService {
    swapRepo;
    userRepo;
    skillRepo;
    notifRepo;
    constructor(swapRepo, userRepo, skillRepo, notifRepo) {
        this.swapRepo = swapRepo;
        this.userRepo = userRepo;
        this.skillRepo = skillRepo;
        this.notifRepo = notifRepo;
    }
    async create(requesterId, dto) {
        if (requesterId === dto.providerId)
            throw new common_1.BadRequestException('Cannot request swap with yourself');
        const user = await this.userRepo.findOne({ where: { id: requesterId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.isPremium) {
            const thirtyDaysAgo = new Date();
            thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
            const monthlyCount = await this.swapRepo.count({
                where: { requesterId, createdAt: (0, typeorm_2.MoreThanOrEqual)(thirtyDaysAgo) },
            });
            if (monthlyCount >= 3)
                throw new common_1.ForbiddenException('Free users can send 3 swap requests per month. Upgrade to Premium for unlimited.');
        }
        const provider = await this.userRepo.findOne({ where: { id: dto.providerId } });
        if (!provider)
            throw new common_1.NotFoundException('Provider not found');
        const swap = this.swapRepo.create({ requesterId, ...dto });
        const saved = await this.swapRepo.save(swap);
        await this.notifRepo.save(this.notifRepo.create({
            userId: dto.providerId,
            type: 'swap_request_received',
            title: `${user.name} sent you a swap request`,
            referenceId: saved.id,
        }));
        return this.findOne(saved.id, requesterId);
    }
    async findAll(userId, query) {
        const countTotal = await this.swapRepo.count({
            where: [
                { requesterId: userId },
                { providerId: userId }
            ]
        });
        if (countTotal === 0) {
            const andi = await this.userRepo.findOne({ where: { googleId: 'dev-andi' } });
            const rian = await this.userRepo.findOne({ where: { googleId: 'dev-rian' } });
            const siti = await this.userRepo.findOne({ where: { googleId: 'dev-siti' } });
            const python = await this.skillRepo.findOne({ where: { name: 'Python' } });
            const flutter = await this.skillRepo.findOne({ where: { name: 'Flutter' } });
            const figma = await this.skillRepo.findOne({ where: { name: 'Figma' } });
            const japanese = await this.skillRepo.findOne({ where: { name: 'Japanese' } });
            if (andi && rian && siti && python && flutter && figma && japanese) {
                await this.swapRepo.save([
                    this.swapRepo.create({
                        requesterId: andi.id,
                        providerId: userId,
                        requesterSkillId: python.id,
                        providerSkillId: flutter.id,
                        status: 'pending',
                        message: 'Hi! I see you want to learn Python. I can teach you in exchange for some Flutter basics.',
                    }),
                    this.swapRepo.create({
                        requesterId: userId,
                        providerId: rian.id,
                        requesterSkillId: flutter.id,
                        providerSkillId: figma.id,
                        status: 'active',
                        message: 'Hey Rian, let’s swap Flutter for Figma design!',
                    }),
                    this.swapRepo.create({
                        requesterId: userId,
                        providerId: siti.id,
                        requesterSkillId: flutter.id,
                        providerSkillId: japanese.id,
                        status: 'done',
                        message: 'Looking forward to learning some Japanese words!',
                        rating: 5,
                        ratingComment: 'Siti was a great teacher!',
                    }),
                ]);
            }
        }
        const page = query.page || 1;
        const limit = query.limit || 20;
        const qb = this.swapRepo.createQueryBuilder('sr')
            .leftJoinAndSelect('sr.requester', 'requester')
            .leftJoinAndSelect('sr.provider', 'provider')
            .leftJoinAndSelect('sr.requesterSkill', 'requesterSkill')
            .leftJoinAndSelect('sr.providerSkill', 'providerSkill');
        if (query.direction === 'sent') {
            qb.where('sr.requesterId = :userId', { userId });
        }
        else if (query.direction === 'received') {
            qb.where('sr.providerId = :userId', { userId });
        }
        else {
            qb.where('(sr.requesterId = :userId OR sr.providerId = :userId)', { userId });
        }
        if (query.status)
            qb.andWhere('sr.status = :status', { status: query.status });
        const [items, total] = await qb
            .orderBy('sr.createdAt', 'DESC')
            .skip((page - 1) * limit)
            .take(limit)
            .getManyAndCount();
        const requests = items.map(sr => ({
            id: sr.id,
            requesterId: sr.requesterId,
            providerId: sr.providerId,
            name: sr.requesterId === userId ? sr.provider.name : sr.requester.name,
            date: new Date(sr.createdAt).toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' }),
            skill1: sr.requesterSkill.name,
            skill2: sr.providerSkill.name,
            message: sr.message || '',
            tabType: sr.status,
            status: sr.status,
            rating: sr.rating,
            ratingComment: sr.ratingComment,
            requester: { id: sr.requester.id, name: sr.requester.name, profileImageUrl: sr.requester.profileImageUrl },
            provider: { id: sr.provider.id, name: sr.provider.name, profileImageUrl: sr.provider.profileImageUrl },
        }));
        return { requests, page, totalPages: Math.ceil(total / limit), total };
    }
    async findOne(id, userId) {
        const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true, requesterSkill: true, providerSkill: true } });
        if (!sr)
            throw new common_1.NotFoundException('Swap request not found');
        if (sr.requesterId !== userId && sr.providerId !== userId)
            throw new common_1.ForbiddenException('Not your swap request');
        return {
            id: sr.id,
            requesterId: sr.requesterId,
            providerId: sr.providerId,
            name: sr.requesterId === userId ? sr.provider.name : sr.requester.name,
            date: new Date(sr.createdAt).toLocaleDateString('en-GB', { day: '2-digit', month: '2-digit', year: 'numeric' }),
            skill1: sr.requesterSkill.name, skill2: sr.providerSkill.name,
            message: sr.message || '', tabType: sr.status, status: sr.status, rating: sr.rating, ratingComment: sr.ratingComment,
            requester: { id: sr.requester.id, name: sr.requester.name, profileImageUrl: sr.requester.profileImageUrl },
            provider: { id: sr.provider.id, name: sr.provider.name, profileImageUrl: sr.provider.profileImageUrl },
        };
    }
    async accept(id, userId) {
        const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
        if (!sr)
            throw new common_1.NotFoundException();
        if (sr.providerId !== userId)
            throw new common_1.ForbiddenException('Only the provider can accept');
        if (sr.status !== 'pending')
            throw new common_1.BadRequestException('Can only accept pending requests');
        sr.status = 'active';
        await this.swapRepo.save(sr);
        await this.notifRepo.save(this.notifRepo.create({ userId: sr.requesterId, type: 'swap_request_accepted', title: `${sr.provider.name} accepted your swap request`, referenceId: sr.id }));
        return this.findOne(id, userId);
    }
    async decline(id, userId) {
        const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
        if (!sr)
            throw new common_1.NotFoundException();
        if (sr.providerId !== userId)
            throw new common_1.ForbiddenException('Only the provider can decline');
        if (sr.status !== 'pending')
            throw new common_1.BadRequestException('Can only decline pending requests');
        sr.status = 'cancelled';
        await this.swapRepo.save(sr);
        await this.notifRepo.save(this.notifRepo.create({ userId: sr.requesterId, type: 'swap_request_declined', title: `${sr.provider.name} declined your swap request`, referenceId: sr.id }));
        return { message: 'Request declined' };
    }
    async cancel(id, userId) {
        const sr = await this.swapRepo.findOne({ where: { id } });
        if (!sr)
            throw new common_1.NotFoundException();
        if (sr.requesterId !== userId && sr.providerId !== userId)
            throw new common_1.ForbiddenException();
        if (sr.status === 'done')
            throw new common_1.BadRequestException('Cannot cancel completed swaps');
        sr.status = 'cancelled';
        await this.swapRepo.save(sr);
        return { message: 'Request cancelled' };
    }
    async complete(id, userId) {
        const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
        if (!sr)
            throw new common_1.NotFoundException();
        if (sr.requesterId !== userId && sr.providerId !== userId)
            throw new common_1.ForbiddenException();
        if (sr.status !== 'active')
            throw new common_1.BadRequestException('Can only complete active swaps');
        sr.status = 'done';
        await this.swapRepo.save(sr);
        await this.userRepo.increment({ id: sr.requesterId }, 'swapCount', 1);
        await this.userRepo.increment({ id: sr.providerId }, 'swapCount', 1);
        const otherUserId = userId === sr.requesterId ? sr.providerId : sr.requesterId;
        const currentUser = userId === sr.requesterId ? sr.requester : sr.provider;
        await this.notifRepo.save(this.notifRepo.create({ userId: otherUserId, type: 'swap_completed', title: `Swap session with ${currentUser.name} completed`, referenceId: sr.id }));
        return this.findOne(id, userId);
    }
    async rate(id, userId, dto) {
        const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
        if (!sr)
            throw new common_1.NotFoundException();
        if (sr.requesterId !== userId && sr.providerId !== userId)
            throw new common_1.ForbiddenException();
        if (sr.status !== 'done')
            throw new common_1.BadRequestException('Can only rate completed swaps');
        if (sr.rating)
            throw new common_1.ConflictException('Already rated');
        sr.rating = dto.rating;
        sr.ratingComment = dto.comment || '';
        sr.ratedAt = new Date();
        await this.swapRepo.save(sr);
        const otherUserId = userId === sr.requesterId ? sr.providerId : sr.requesterId;
        const currentUser = userId === sr.requesterId ? sr.requester : sr.provider;
        await this.notifRepo.save(this.notifRepo.create({ userId: otherUserId, type: 'rating_received', title: `${currentUser.name} rated you ${dto.rating} stars`, referenceId: sr.id }));
        return this.findOne(id, userId);
    }
};
exports.SwapRequestsService = SwapRequestsService;
exports.SwapRequestsService = SwapRequestsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(swap_request_entity_1.SwapRequest)),
    __param(1, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(2, (0, typeorm_1.InjectRepository)(skill_entity_1.Skill)),
    __param(3, (0, typeorm_1.InjectRepository)(notification_entity_1.Notification)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], SwapRequestsService);
//# sourceMappingURL=swap-requests.service.js.map