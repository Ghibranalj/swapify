import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { Skill } from '../skills/entities/skill.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { Notification } from '../notifications/entities/notification.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(SwapRequest) private swapRepo: Repository<SwapRequest>,
    @InjectRepository(Notification) private notifRepo: Repository<Notification>,
  ) {}

  async getUsers(query?: { search?: string; page?: number; limit?: number }) {
    const page = query?.page || 1;
    const limit = query?.limit || 10;
    const where: any = {};
    if (query?.search) where.name = Like(`%${query.search}%`);
    const [users, total] = await this.userRepo.findAndCount({ where, skip: (page - 1) * limit, take: limit, order: { createdAt: 'DESC' } });
    return { users: users.map(u => ({ id: u.id, name: u.name, email: u.email, status: u.status, isPremium: u.isPremium, isAdmin: u.isAdmin, swapCount: u.swapCount, createdAt: u.createdAt })), total, page, totalPages: Math.ceil(total / limit) };
  }

  async updateUser(id: string, data: any) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException();
    Object.assign(user, data);
    return this.userRepo.save(user);
  }

  async deleteUser(id: string) {
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException();
    await this.userRepo.remove(user);
    return { message: 'User deleted' };
  }

  async approveUser(id: string) { return this.userRepo.update(id, { status: 'active' }); }
  async suspendUser(id: string) { return this.userRepo.update(id, { status: 'suspended' }); }
  async restoreUser(id: string) { return this.userRepo.update(id, { status: 'active' }); }

  async getSkills(query?: { search?: string }) {
    const where: any = {};
    if (query?.search) where.name = Like(`%${query.search}%`);
    return this.skillRepo.find({ where, order: { name: 'ASC' } });
  }

  async createSkill(dto: { name: string; category: string }) {
    return this.skillRepo.save(this.skillRepo.create(dto));
  }

  async updateSkill(id: string, dto: any) {
    const skill = await this.skillRepo.findOne({ where: { id } });
    if (!skill) throw new NotFoundException();
    Object.assign(skill, dto);
    return this.skillRepo.save(skill);
  }

  async deleteSkill(id: string) {
    const skill = await this.skillRepo.findOne({ where: { id } });
    if (!skill) throw new NotFoundException();
    await this.skillRepo.remove(skill);
    return { message: 'Skill deleted' };
  }

  async getStats() {
    const totalUsers = await this.userRepo.count();
    const totalSkills = await this.skillRepo.count();
    const activeRequestCount = await this.swapRepo.count({ where: { status: 'active' } });
    return { totalUsers, totalSkills, activeRequestCount, growthPercent: 24, growthPeriod: 'this week' };
  }

  async getAlerts(query?: { page?: number; limit?: number }) {
    const page = query?.page || 1;
    const limit = query?.limit || 20;
    const [alerts, total] = await this.notifRepo.findAndCount({ order: { createdAt: 'DESC' }, skip: (page - 1) * limit, take: limit });
    return { alerts, total, page, totalPages: Math.ceil(total / limit) };
  }
}
