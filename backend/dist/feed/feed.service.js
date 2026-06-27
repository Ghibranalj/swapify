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
exports.FeedService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const user_entity_1 = require("../users/entities/user.entity");
const user_skill_entity_1 = require("../skills/entities/user-skill.entity");
const user_learning_goal_entity_1 = require("../skills/entities/user-learning-goal.entity");
const skill_entity_1 = require("../skills/entities/skill.entity");
const swap_request_entity_1 = require("../swap-requests/entities/swap-request.entity");
const certificate_entity_1 = require("../certificates/entities/certificate.entity");
let FeedService = class FeedService {
    userRepo;
    userSkillRepo;
    goalRepo;
    skillRepo;
    swapRepo;
    certRepo;
    constructor(userRepo, userSkillRepo, goalRepo, skillRepo, swapRepo, certRepo) {
        this.userRepo = userRepo;
        this.userSkillRepo = userSkillRepo;
        this.goalRepo = goalRepo;
        this.skillRepo = skillRepo;
        this.swapRepo = swapRepo;
        this.certRepo = certRepo;
    }
    async discover(userId, query) {
        const page = query.page || 1;
        const limit = query.limit || 20;
        const myGoals = await this.goalRepo.find({ where: { userId }, relations: { skill: true } });
        const mySkills = await this.userSkillRepo.find({ where: { userId }, relations: { skill: true } });
        const myGoalSkillIds = myGoals.map(g => g.skillId);
        const mySkillIds = mySkills.map(s => s.skillId);
        let usersQuery = this.userRepo.createQueryBuilder('user')
            .where('user.id != :userId', { userId })
            .andWhere('user.status = :status', { status: 'active' });
        if (query.search) {
            usersQuery = usersQuery.andWhere('user.name LIKE :search', { search: `%${query.search}%` });
        }
        const allUsers = await usersQuery.getMany();
        const scoredUsers = [];
        for (const user of allUsers) {
            const theirSkills = await this.userSkillRepo.find({ where: { userId: user.id }, relations: { skill: true } });
            const theirGoals = await this.goalRepo.find({ where: { userId: user.id }, relations: { skill: true } });
            const theirCerts = await this.certRepo.find({ where: { userId: user.id } });
            if (query.category) {
                const hasCategory = theirSkills.some(s => s.skill.category === query.category);
                if (!hasCategory)
                    continue;
            }
            let matchScore = 0;
            const matchingSkills = [];
            for (const ts of theirSkills) {
                if (myGoalSkillIds.includes(ts.skillId)) {
                    matchScore += 10;
                    matchingSkills.push(ts.skill.name);
                }
            }
            for (const tg of theirGoals) {
                if (mySkillIds.includes(tg.skillId)) {
                    matchScore += 5;
                }
            }
            if (user.isPremium)
                matchScore += 15;
            const ratings = await this.swapRepo
                .createQueryBuilder('sr')
                .where('(sr.requesterId = :uid OR sr.providerId = :uid)', { uid: user.id })
                .andWhere('sr.rating IS NOT NULL')
                .select('AVG(sr.rating)', 'avg')
                .addSelect('COUNT(sr.rating)', 'count')
                .getRawOne();
            const avgRating = ratings?.avg ? parseFloat(parseFloat(ratings.avg).toFixed(1)) : 0;
            const categories = [...new Set(theirSkills.map(s => s.skill.category))];
            const sortedSkills = [...theirSkills].sort((a, b) => {
                if (query.category) {
                    const aMatch = a.skill.category === query.category ? 1 : 0;
                    const bMatch = b.skill.category === query.category ? 1 : 0;
                    return bMatch - aMatch;
                }
                return 0;
            });
            scoredUsers.push({
                id: user.id,
                name: user.name,
                bio: user.bio || '',
                profileImageUrl: user.profileImageUrl || '',
                imageAsset: user.profileImageUrl || '',
                rating: avgRating.toString(),
                swaps: user.swapCount.toString(),
                isPremium: user.isPremium,
                categories,
                skills: sortedSkills.map(s => s.skill.name),
                learningGoals: theirGoals.map(g => g.skill.name),
                certificates: theirCerts.map(c => c.fileUrl),
                matchScore,
            });
        }
        switch (query.sort) {
            case 'rating':
                scoredUsers.sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating));
                break;
            case 'newest':
                scoredUsers.sort((a, b) => 0);
                break;
            default:
                scoredUsers.sort((a, b) => b.matchScore - a.matchScore);
        }
        const total = scoredUsers.length;
        const paginated = scoredUsers.slice((page - 1) * limit, page * limit);
        return {
            users: paginated,
            page,
            totalPages: Math.ceil(total / limit),
            total,
        };
    }
};
exports.FeedService = FeedService;
exports.FeedService = FeedService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __param(1, (0, typeorm_1.InjectRepository)(user_skill_entity_1.UserSkill)),
    __param(2, (0, typeorm_1.InjectRepository)(user_learning_goal_entity_1.UserLearningGoal)),
    __param(3, (0, typeorm_1.InjectRepository)(skill_entity_1.Skill)),
    __param(4, (0, typeorm_1.InjectRepository)(swap_request_entity_1.SwapRequest)),
    __param(5, (0, typeorm_1.InjectRepository)(certificate_entity_1.Certificate)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository,
        typeorm_2.Repository])
], FeedService);
//# sourceMappingURL=feed.service.js.map