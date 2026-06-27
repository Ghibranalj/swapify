import { Injectable, ForbiddenException, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual } from 'typeorm';
import { SwapRequest } from './entities/swap-request.entity';
import { User } from '../users/entities/user.entity';
import { Skill } from '../skills/entities/skill.entity';
import { Notification } from '../notifications/entities/notification.entity';

@Injectable()
export class SwapRequestsService {
  constructor(
    @InjectRepository(SwapRequest) private swapRepo: Repository<SwapRequest>,
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Notification) private notifRepo: Repository<Notification>,
  ) {}

  async create(requesterId: string, dto: { providerId: string; requesterSkillId: string; providerSkillId: string; message?: string }) {
    if (requesterId === dto.providerId) throw new BadRequestException('Cannot request swap with yourself');

    const user = await this.userRepo.findOne({ where: { id: requesterId } });
    if (!user) throw new NotFoundException('User not found');
    if (!user.isPremium) {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      const monthlyCount = await this.swapRepo.count({
        where: { requesterId, createdAt: MoreThanOrEqual(thirtyDaysAgo) },
      });
      if (monthlyCount >= 3) throw new ForbiddenException('Free users can send 3 swap requests per month. Upgrade to Premium for unlimited.');
    }

    const provider = await this.userRepo.findOne({ where: { id: dto.providerId } });
    if (!provider) throw new NotFoundException('Provider not found');

    const swap = this.swapRepo.create({ requesterId, ...dto });
    const saved = await this.swapRepo.save(swap);

    // Notify provider
    await this.notifRepo.save(this.notifRepo.create({
      userId: dto.providerId,
      type: 'swap_request_received',
      title: `${user.name} sent you a swap request`,
      referenceId: saved.id,
    }));

    return this.findOne(saved.id, requesterId);
  }

  async findAll(userId: string, query: { status?: string; direction?: string; page?: number; limit?: number }) {
    // Seed mock requests if user has none
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
    } else if (query.direction === 'received') {
      qb.where('sr.providerId = :userId', { userId });
    } else {
      qb.where('(sr.requesterId = :userId OR sr.providerId = :userId)', { userId });
    }

    if (query.status) qb.andWhere('sr.status = :status', { status: query.status });

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

  async findOne(id: string, userId: string) {
    const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true, requesterSkill: true, providerSkill: true } });
    if (!sr) throw new NotFoundException('Swap request not found');
    if (sr.requesterId !== userId && sr.providerId !== userId) throw new ForbiddenException('Not your swap request');
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

  async accept(id: string, userId: string) {
    const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
    if (!sr) throw new NotFoundException();
    if (sr.providerId !== userId) throw new ForbiddenException('Only the provider can accept');
    if (sr.status !== 'pending') throw new BadRequestException('Can only accept pending requests');
    sr.status = 'active';
    await this.swapRepo.save(sr);
    await this.notifRepo.save(this.notifRepo.create({ userId: sr.requesterId, type: 'swap_request_accepted', title: `${sr.provider.name} accepted your swap request`, referenceId: sr.id }));
    return this.findOne(id, userId);
  }

  async decline(id: string, userId: string) {
    const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
    if (!sr) throw new NotFoundException();
    if (sr.providerId !== userId) throw new ForbiddenException('Only the provider can decline');
    if (sr.status !== 'pending') throw new BadRequestException('Can only decline pending requests');
    sr.status = 'cancelled';
    await this.swapRepo.save(sr);
    await this.notifRepo.save(this.notifRepo.create({ userId: sr.requesterId, type: 'swap_request_declined', title: `${sr.provider.name} declined your swap request`, referenceId: sr.id }));
    return { message: 'Request declined' };
  }

  async cancel(id: string, userId: string) {
    const sr = await this.swapRepo.findOne({ where: { id } });
    if (!sr) throw new NotFoundException();
    if (sr.requesterId !== userId && sr.providerId !== userId) throw new ForbiddenException();
    if (sr.status === 'done') throw new BadRequestException('Cannot cancel completed swaps');
    sr.status = 'cancelled';
    await this.swapRepo.save(sr);
    return { message: 'Request cancelled' };
  }

  async complete(id: string, userId: string) {
    const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
    if (!sr) throw new NotFoundException();
    if (sr.requesterId !== userId && sr.providerId !== userId) throw new ForbiddenException();
    if (sr.status !== 'active') throw new BadRequestException('Can only complete active swaps');
    sr.status = 'done';
    await this.swapRepo.save(sr);
    await this.userRepo.increment({ id: sr.requesterId }, 'swapCount', 1);
    await this.userRepo.increment({ id: sr.providerId }, 'swapCount', 1);
    const otherUserId = userId === sr.requesterId ? sr.providerId : sr.requesterId;
    const currentUser = userId === sr.requesterId ? sr.requester : sr.provider;
    await this.notifRepo.save(this.notifRepo.create({ userId: otherUserId, type: 'swap_completed', title: `Swap session with ${currentUser.name} completed`, referenceId: sr.id }));
    return this.findOne(id, userId);
  }

  async rate(id: string, userId: string, dto: { rating: number; comment?: string }) {
    const sr = await this.swapRepo.findOne({ where: { id }, relations: { requester: true, provider: true } });
    if (!sr) throw new NotFoundException();
    if (sr.requesterId !== userId && sr.providerId !== userId) throw new ForbiddenException();
    if (sr.status !== 'done') throw new BadRequestException('Can only rate completed swaps');
    if (sr.rating) throw new ConflictException('Already rated');
    sr.rating = dto.rating;
    sr.ratingComment = dto.comment || '';
    sr.ratedAt = new Date();
    await this.swapRepo.save(sr);
    const otherUserId = userId === sr.requesterId ? sr.providerId : sr.requesterId;
    const currentUser = userId === sr.requesterId ? sr.requester : sr.provider;
    await this.notifRepo.save(this.notifRepo.create({ userId: otherUserId, type: 'rating_received', title: `${currentUser.name} rated you ${dto.rating} stars`, referenceId: sr.id }));
    return this.findOne(id, userId);
  }
}
