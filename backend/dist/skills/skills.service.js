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
exports.SkillsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const skill_entity_1 = require("./entities/skill.entity");
const user_skill_entity_1 = require("./entities/user-skill.entity");
const user_learning_goal_entity_1 = require("./entities/user-learning-goal.entity");
const user_entity_1 = require("../users/entities/user.entity");
let SkillsService = class SkillsService {
    skillRepo;
    userSkillRepo;
    goalRepo;
    userRepo;
    constructor(skillRepo, userSkillRepo, goalRepo, userRepo) {
        this.skillRepo = skillRepo;
        this.userSkillRepo = userSkillRepo;
        this.goalRepo = goalRepo;
        this.userRepo = userRepo;
    }
    async findAll(query) {
        const page = query?.page || 1;
        const limit = query?.limit || 20;
        const where = {};
        if (query?.category && query.category !== 'All') {
            where.category = query.category;
        }
        if (query?.search) {
            where.name = (0, typeorm_2.Like)(`%${query.search}%`);
        }
        const [skills, total] = await this.skillRepo.findAndCount({
            where,
            skip: (page - 1) * limit,
            take: limit,
            order: { name: 'ASC' },
        });
        return {
            skills,
            categories: ['All', 'Design', 'Coding', 'Language', 'Music', 'Art'],
            total,
            page,
            totalPages: Math.ceil(total / limit),
        };
    }
    async create(dto) {
        const existing = await this.skillRepo.findOne({ where: { name: dto.name } });
        if (existing) {
            throw new common_1.ConflictException(`Skill "${dto.name}" already exists`);
        }
        const skill = this.skillRepo.create({ ...dto, isUserCreated: true });
        return this.skillRepo.save(skill);
    }
    async getUserSkills(userId) {
        const userSkills = await this.userSkillRepo.find({
            where: { userId },
            relations: { skill: true },
            order: { createdAt: 'DESC' },
        });
        return {
            skills: userSkills.map((us) => ({
                id: us.id,
                skillId: us.skillId,
                name: us.skill.name,
                category: us.skill.category,
                proficiency: us.proficiency,
            })),
        };
    }
    async addUserSkill(userId, dto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.isPremium) {
            const count = await this.userSkillRepo.count({ where: { userId } });
            if (count >= 3) {
                throw new common_1.ForbiddenException('Free users can add up to 3 skills. Upgrade to Premium for unlimited skills.');
            }
        }
        const skill = await this.skillRepo.findOne({ where: { id: dto.skillId } });
        if (!skill)
            throw new common_1.NotFoundException('Skill not found');
        const existing = await this.userSkillRepo.findOne({ where: { userId, skillId: dto.skillId } });
        if (existing)
            throw new common_1.ConflictException('You already have this skill');
        const userSkill = this.userSkillRepo.create({
            userId,
            skillId: dto.skillId,
            proficiency: dto.proficiency,
        });
        const saved = await this.userSkillRepo.save(userSkill);
        return { id: saved.id, skillId: saved.skillId, name: skill.name, category: skill.category, proficiency: saved.proficiency };
    }
    async removeUserSkill(userId, id) {
        const userSkill = await this.userSkillRepo.findOne({ where: { id, userId } });
        if (!userSkill)
            throw new common_1.NotFoundException('Skill not found in your profile');
        await this.userSkillRepo.remove(userSkill);
        return { message: 'Skill removed' };
    }
    async getLearningGoals(userId) {
        const goals = await this.goalRepo.find({
            where: { userId },
            relations: { skill: true },
            order: { createdAt: 'DESC' },
        });
        return {
            goals: goals.map((g) => ({
                id: g.id,
                skillId: g.skillId,
                name: g.skill.name,
                category: g.skill.category,
                priority: g.priority,
            })),
        };
    }
    async addLearningGoal(userId, dto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.isPremium) {
            const count = await this.goalRepo.count({ where: { userId } });
            if (count >= 3) {
                throw new common_1.ForbiddenException('Free users can add up to 3 learning goals. Upgrade to Premium for unlimited goals.');
            }
        }
        const skill = await this.skillRepo.findOne({ where: { id: dto.skillId } });
        if (!skill)
            throw new common_1.NotFoundException('Skill not found');
        const existing = await this.goalRepo.findOne({ where: { userId, skillId: dto.skillId } });
        if (existing)
            throw new common_1.ConflictException('You already want to learn this skill');
        const goal = this.goalRepo.create({ userId, skillId: dto.skillId, priority: dto.priority });
        const saved = await this.goalRepo.save(goal);
        return { id: saved.id, skillId: saved.skillId, name: skill.name, category: skill.category, priority: saved.priority };
    }
    async removeLearningGoal(userId, id) {
        const goal = await this.goalRepo.findOne({ where: { id, userId } });
        if (!goal)
            throw new common_1.NotFoundException('Learning goal not found');
        await this.goalRepo.remove(goal);
        return { message: 'Learning goal removed' };
    }
};
exports.SkillsService = SkillsService;
exports.SkillsService = SkillsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(skill_entity_1.Skill)),
    __param(1, (0, typeorm_1.InjectRepository)(user_skill_entity_1.UserSkill)),
    __param(2, (0, typeorm_1.InjectRepository)(user_learning_goal_entity_1.UserLearningGoal)),
    __param(3, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], SkillsService);
//# sourceMappingURL=skills.service.js.map