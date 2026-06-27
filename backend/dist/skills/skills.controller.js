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
exports.SkillsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
const user_entity_1 = require("../users/entities/user.entity");
const skills_service_1 = require("./skills.service");
const create_skill_dto_1 = require("./dto/create-skill.dto");
const add_user_skill_dto_1 = require("./dto/add-user-skill.dto");
const add_learning_goal_dto_1 = require("./dto/add-learning-goal.dto");
let SkillsController = class SkillsController {
    skillsService;
    constructor(skillsService) {
        this.skillsService = skillsService;
    }
    findAll(category, search, page, limit) {
        return this.skillsService.findAll({
            category,
            search,
            page: parseInt(page || '', 10) || 1,
            limit: parseInt(limit || '', 10) || 20,
        });
    }
    create(dto) {
        return this.skillsService.create(dto);
    }
    getUserSkills(user) {
        return this.skillsService.getUserSkills(user.id);
    }
    addUserSkill(user, dto) {
        return this.skillsService.addUserSkill(user.id, dto);
    }
    removeUserSkill(user, id) {
        return this.skillsService.removeUserSkill(user.id, id);
    }
    getLearningGoals(user) {
        return this.skillsService.getLearningGoals(user.id);
    }
    addLearningGoal(user, dto) {
        return this.skillsService.addLearningGoal(user.id, dto);
    }
    removeLearningGoal(user, id) {
        return this.skillsService.removeLearningGoal(user.id, id);
    }
};
exports.SkillsController = SkillsController;
__decorate([
    (0, common_1.Get)('skills'),
    (0, swagger_1.ApiOperation)({ summary: 'List all skills' }),
    (0, swagger_1.ApiQuery)({ name: 'category', required: false }),
    (0, swagger_1.ApiQuery)({ name: 'search', required: false }),
    (0, swagger_1.ApiQuery)({ name: 'page', required: false, type: Number }),
    (0, swagger_1.ApiQuery)({ name: 'limit', required: false, type: Number }),
    __param(0, (0, common_1.Query)('category')),
    __param(1, (0, common_1.Query)('search')),
    __param(2, (0, common_1.Query)('page')),
    __param(3, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, String, String, String]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Post)('skills'),
    (0, swagger_1.ApiOperation)({ summary: 'Create a custom skill' }),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_skill_dto_1.CreateSkillDto]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('users/me/skills'),
    (0, swagger_1.ApiOperation)({ summary: 'Get my skills' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "getUserSkills", null);
__decorate([
    (0, common_1.Post)('users/me/skills'),
    (0, swagger_1.ApiOperation)({ summary: 'Add a skill to my profile' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, add_user_skill_dto_1.AddUserSkillDto]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "addUserSkill", null);
__decorate([
    (0, common_1.Delete)('users/me/skills/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Remove a skill from my profile' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "removeUserSkill", null);
__decorate([
    (0, common_1.Get)('users/me/learning-goals'),
    (0, swagger_1.ApiOperation)({ summary: 'Get my learning goals' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "getLearningGoals", null);
__decorate([
    (0, common_1.Post)('users/me/learning-goals'),
    (0, swagger_1.ApiOperation)({ summary: 'Add a learning goal' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, add_learning_goal_dto_1.AddLearningGoalDto]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "addLearningGoal", null);
__decorate([
    (0, common_1.Delete)('users/me/learning-goals/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Remove a learning goal' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SkillsController.prototype, "removeLearningGoal", null);
exports.SkillsController = SkillsController = __decorate([
    (0, swagger_1.ApiTags)('Skills'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, common_1.Controller)(),
    __metadata("design:paramtypes", [skills_service_1.SkillsService])
], SkillsController);
//# sourceMappingURL=skills.controller.js.map