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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("./entities/user.entity");
const user_skill_entity_1 = require("../skills/entities/user-skill.entity");
const user_learning_goal_entity_1 = require("../skills/entities/user-learning-goal.entity");
const certificate_entity_1 = require("../certificates/entities/certificate.entity");
const swap_request_entity_1 = require("../swap-requests/entities/swap-request.entity");
let UsersService = class UsersService {
    userRepo;
    userSkillRepo;
    learningGoalRepo;
    certificateRepo;
    swapRequestRepo;
    constructor(userRepo, userSkillRepo, learningGoalRepo, certificateRepo, swapRequestRepo) {
        this.userRepo = userRepo;
        this.userSkillRepo = userSkillRepo;
        this.learningGoalRepo = learningGoalRepo;
        this.certificateRepo = certificateRepo;
        this.swapRequestRepo = swapRequestRepo;
    }
    async computeRating(userId) {
        const result = await this.swapRequestRepo
            .createQueryBuilder('sr')
            .select('AVG(sr.rating)', 'avg')
            .addSelect('COUNT(sr.rating)', 'count')
            .where('(sr.requesterId = :userId OR sr.providerId = :userId)', { userId })
            .andWhere('sr.rating IS NOT NULL')
            .getRawOne();
        return {
            averageRating: result?.avg ? parseFloat(Number(result.avg).toFixed(2)) : 0,
            totalRatings: result?.count ? parseInt(result.count, 10) : 0,
        };
    }
    async getProfile(userId) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
        });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        const skills = await this.userSkillRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const learningGoals = await this.learningGoalRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const certificates = await this.certificateRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const { averageRating, totalRatings } = await this.computeRating(userId);
        return {
            id: user.id,
            name: user.name,
            email: user.email,
            bio: user.bio,
            profileImageUrl: user.profileImageUrl,
            isPremium: user.isPremium,
            premiumExpiresAt: user.premiumExpiresAt,
            swapCount: user.swapCount,
            status: user.status,
            isAdmin: user.isAdmin,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
            averageRating,
            totalRatings,
            skills: skills.map((us) => ({
                id: us.id,
                skillId: us.skillId,
                name: us.skill?.name ?? '',
                category: us.skill?.category ?? '',
                proficiency: us.proficiency,
                createdAt: us.createdAt,
            })),
            learningGoals: learningGoals.map((lg) => ({
                id: lg.id,
                skillId: lg.skillId,
                name: lg.skill?.name ?? '',
                category: lg.skill?.category ?? '',
                priority: lg.priority,
                createdAt: lg.createdAt,
            })),
            certificates: certificates.map((c) => ({
                id: c.id,
                title: c.title,
                fileUrl: c.fileUrl,
                fileName: c.fileName,
                fileType: c.fileType,
                fileSize: c.fileSize,
                skillId: c.skillId,
                skillName: c.skill?.name ?? null,
                createdAt: c.createdAt,
            })),
        };
    }
    async updateProfile(userId, dto) {
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        if (dto.name !== undefined) {
            user.name = dto.name;
        }
        if (dto.bio !== undefined) {
            user.bio = dto.bio;
        }
        await this.userRepo.save(user);
        return this.getProfile(userId);
    }
    async getPublicProfile(userId) {
        const user = await this.userRepo.findOne({
            where: { id: userId },
        });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        const skills = await this.userSkillRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const learningGoals = await this.learningGoalRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const certificates = await this.certificateRepo.find({
            where: { userId },
            relations: { skill: true },
        });
        const { averageRating, totalRatings } = await this.computeRating(userId);
        return {
            id: user.id,
            name: user.name,
            bio: user.bio,
            profileImageUrl: user.profileImageUrl,
            isPremium: user.isPremium,
            swapCount: user.swapCount,
            createdAt: user.createdAt,
            averageRating,
            totalRatings,
            skills: skills.map((us) => ({
                id: us.id,
                skillId: us.skillId,
                name: us.skill?.name ?? '',
                category: us.skill?.category ?? '',
                proficiency: us.proficiency,
            })),
            learningGoals: learningGoals.map((lg) => ({
                id: lg.id,
                skillId: lg.skillId,
                name: lg.skill?.name ?? '',
                category: lg.skill?.category ?? '',
                priority: lg.priority,
            })),
            certificates: certificates.map((c) => ({
                id: c.id,
                title: c.title,
                fileUrl: c.fileUrl,
                fileType: c.fileType,
                skillId: c.skillId,
                skillName: c.skill?.name ?? null,
                createdAt: c.createdAt,
            })),
        };
    }
    async uploadProfileImage(userId, fileUrl) {
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user) {
            throw new common_1.NotFoundException('User not found');
        }
        user.profileImageUrl = fileUrl;
        await this.userRepo.save(user);
        return { profileImageUrl: user.profileImageUrl };
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(user_skill_entity_1.UserSkill)),
    __param(2, (0, typeorm_1.InjectRepository)(user_learning_goal_entity_1.UserLearningGoal)),
    __param(3, (0, typeorm_1.InjectRepository)(certificate_entity_1.Certificate)),
    __param(4, (0, typeorm_1.InjectRepository)(swap_request_entity_1.SwapRequest)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], UsersService);
//# sourceMappingURL=users.service.js.map