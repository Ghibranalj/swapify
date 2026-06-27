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
exports.SubscriptionsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const subscription_entity_1 = require("./entities/subscription.entity");
const user_entity_1 = require("../users/entities/user.entity");
const PLANS = {
    monthly: { price: 175000, days: 30 },
    yearly: { price: 1550000, days: 365 },
};
let SubscriptionsService = class SubscriptionsService {
    subRepo;
    userRepo;
    constructor(subRepo, userRepo) {
        this.subRepo = subRepo;
        this.userRepo = userRepo;
    }
    getPlans() {
        return {
            plans: [
                { id: 'monthly', name: 'Monthly', price: 175000, currency: 'IDR', interval: 'month', features: ['Unlimited skill swaps', 'Priority matching', 'Full profile customization', 'Cancel anytime'] },
                { id: 'yearly', name: 'Yearly', price: 1550000, currency: 'IDR', interval: 'year', savings: 550000, badge: 'BEST VALUE', features: ['Everything in Monthly', 'Save Rp 550,000/year', '2 months free'] },
            ],
        };
    }
    async subscribe(userId, dto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (user.isPremium)
            throw new common_1.ConflictException('Already subscribed to Premium');
        const plan = PLANS[dto.planId];
        if (!plan)
            throw new common_1.BadRequestException('Invalid plan');
        const now = new Date();
        const expires = new Date(now);
        expires.setDate(expires.getDate() + plan.days);
        const sub = this.subRepo.create({ userId, plan: dto.planId, price: plan.price, paymentMethod: dto.paymentMethod, startsAt: now, expiresAt: expires });
        const saved = await this.subRepo.save(sub);
        user.isPremium = true;
        user.premiumExpiresAt = expires;
        await this.userRepo.save(user);
        return { subscriptionId: saved.id, status: 'active', plan: dto.planId, expiresAt: expires };
    }
    async getMySubscription(userId) {
        const sub = await this.subRepo.findOne({ where: { userId, status: 'active' }, order: { createdAt: 'DESC' } });
        if (!sub)
            return { subscription: null };
        if (new Date(sub.expiresAt) < new Date()) {
            sub.status = 'expired';
            await this.subRepo.save(sub);
            await this.userRepo.update(userId, { isPremium: false, premiumExpiresAt: undefined });
            return { subscription: null };
        }
        return { subscription: sub };
    }
    async cancel(userId) {
        const sub = await this.subRepo.findOne({ where: { userId, status: 'active' }, order: { createdAt: 'DESC' } });
        if (!sub)
            throw new common_1.NotFoundException('No active subscription');
        sub.status = 'cancelled';
        await this.subRepo.save(sub);
        return { message: 'Subscription cancelled. Premium remains active until ' + sub.expiresAt.toISOString() };
    }
};
exports.SubscriptionsService = SubscriptionsService;
exports.SubscriptionsService = SubscriptionsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(subscription_entity_1.Subscription)),
    __param(1, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], SubscriptionsService);
//# sourceMappingURL=subscriptions.service.js.map