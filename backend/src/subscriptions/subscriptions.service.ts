import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Subscription } from './entities/subscription.entity';
import { User } from '../users/entities/user.entity';

const PLANS: Record<string, { price: number; days: number }> = {
  monthly: { price: 175000, days: 30 },
  yearly: { price: 1550000, days: 365 },
};

@Injectable()
export class SubscriptionsService {
  constructor(
    @InjectRepository(Subscription) private subRepo: Repository<Subscription>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  getPlans() {
    return {
      plans: [
        { id: 'monthly', name: 'Monthly', price: 175000, currency: 'IDR', interval: 'month', features: ['Unlimited skill swaps', 'Priority matching', 'Full profile customization', 'Cancel anytime'] },
        { id: 'yearly', name: 'Yearly', price: 1550000, currency: 'IDR', interval: 'year', savings: 550000, badge: 'BEST VALUE', features: ['Everything in Monthly', 'Save Rp 550,000/year', '2 months free'] },
      ],
    };
  }

  async subscribe(userId: string, dto: { planId: string; paymentMethod: string; paymentDetails?: any }) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (user.isPremium) throw new ConflictException('Already subscribed to Premium');

    const plan = PLANS[dto.planId];
    if (!plan) throw new BadRequestException('Invalid plan');

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

  async getMySubscription(userId: string) {
    const sub = await this.subRepo.findOne({ where: { userId, status: 'active' }, order: { createdAt: 'DESC' } });
    if (!sub) return { subscription: null };
    if (new Date(sub.expiresAt) < new Date()) {
      sub.status = 'expired';
      await this.subRepo.save(sub);
      await this.userRepo.update(userId, { isPremium: false, premiumExpiresAt: undefined as any });
      return { subscription: null };
    }
    return { subscription: sub };
  }

  async cancel(userId: string) {
    const sub = await this.subRepo.findOne({ where: { userId, status: 'active' }, order: { createdAt: 'DESC' } });
    if (!sub) throw new NotFoundException('No active subscription');
    sub.status = 'cancelled';
    await this.subRepo.save(sub);
    return { message: 'Subscription cancelled. Premium remains active until ' + sub.expiresAt.toISOString() };
  }
}
