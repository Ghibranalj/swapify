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
exports.AdminService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("../users/entities/user.entity");
const skill_entity_1 = require("../skills/entities/skill.entity");
const swap_request_entity_1 = require("../swap-requests/entities/swap-request.entity");
const notification_entity_1 = require("../notifications/entities/notification.entity");
let AdminService = class AdminService {
    userRepo;
    skillRepo;
    swapRepo;
    notifRepo;
    constructor(userRepo, skillRepo, swapRepo, notifRepo) {
        this.userRepo = userRepo;
        this.skillRepo = skillRepo;
        this.swapRepo = swapRepo;
        this.notifRepo = notifRepo;
    }
    async getUsers(query) {
        const page = query?.page || 1;
        const limit = query?.limit || 10;
        const where = {};
        if (query?.search)
            where.name = (0, typeorm_2.Like)(`%${query.search}%`);
        const [users, total] = await this.userRepo.findAndCount({ where, skip: (page - 1) * limit, take: limit, order: { createdAt: 'DESC' } });
        return { users: users.map(u => ({ id: u.id, name: u.name, email: u.email, status: u.status, isPremium: u.isPremium, isAdmin: u.isAdmin, swapCount: u.swapCount, createdAt: u.createdAt })), total, page, totalPages: Math.ceil(total / limit) };
    }
    async updateUser(id, data) {
        const user = await this.userRepo.findOne({ where: { id } });
        if (!user)
            throw new common_1.NotFoundException();
        Object.assign(user, data);
        return this.userRepo.save(user);
    }
    async deleteUser(id) {
        const user = await this.userRepo.findOne({ where: { id } });
        if (!user)
            throw new common_1.NotFoundException();
        await this.userRepo.remove(user);
        return { message: 'User deleted' };
    }
    async approveUser(id) { return this.userRepo.update(id, { status: 'active' }); }
    async suspendUser(id) { return this.userRepo.update(id, { status: 'suspended' }); }
    async restoreUser(id) { return this.userRepo.update(id, { status: 'active' }); }
    async getSkills(query) {
        const where = {};
        if (query?.search)
            where.name = (0, typeorm_2.Like)(`%${query.search}%`);
        return this.skillRepo.find({ where, order: { name: 'ASC' } });
    }
    async createSkill(dto) {
        return this.skillRepo.save(this.skillRepo.create(dto));
    }
    async updateSkill(id, dto) {
        const skill = await this.skillRepo.findOne({ where: { id } });
        if (!skill)
            throw new common_1.NotFoundException();
        Object.assign(skill, dto);
        return this.skillRepo.save(skill);
    }
    async deleteSkill(id) {
        const skill = await this.skillRepo.findOne({ where: { id } });
        if (!skill)
            throw new common_1.NotFoundException();
        await this.skillRepo.remove(skill);
        return { message: 'Skill deleted' };
    }
    async getStats() {
        const totalUsers = await this.userRepo.count();
        const totalSkills = await this.skillRepo.count();
        const activeRequestCount = await this.swapRepo.count({ where: { status: 'active' } });
        return { totalUsers, totalSkills, activeRequestCount, growthPercent: 24, growthPeriod: 'this week' };
    }
    async getAlerts(query) {
        const page = query?.page || 1;
        const limit = query?.limit || 20;
        const [alerts, total] = await this.notifRepo.findAndCount({ order: { createdAt: 'DESC' }, skip: (page - 1) * limit, take: limit });
        return { alerts, total, page, totalPages: Math.ceil(total / limit) };
    }
};
exports.AdminService = AdminService;
exports.AdminService = AdminService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(skill_entity_1.Skill)),
    __param(2, (0, typeorm_1.InjectRepository)(swap_request_entity_1.SwapRequest)),
    __param(3, (0, typeorm_1.InjectRepository)(notification_entity_1.Notification)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], AdminService);
//# sourceMappingURL=admin.service.js.map