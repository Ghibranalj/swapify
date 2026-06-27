"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FeedModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const feed_service_1 = require("./feed.service");
const feed_controller_1 = require("./feed.controller");
const user_entity_1 = require("../users/entities/user.entity");
const user_skill_entity_1 = require("../skills/entities/user-skill.entity");
const user_learning_goal_entity_1 = require("../skills/entities/user-learning-goal.entity");
const skill_entity_1 = require("../skills/entities/skill.entity");
const swap_request_entity_1 = require("../swap-requests/entities/swap-request.entity");
const certificate_entity_1 = require("../certificates/entities/certificate.entity");
let FeedModule = class FeedModule {
};
exports.FeedModule = FeedModule;
exports.FeedModule = FeedModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([user_entity_1.User, user_skill_entity_1.UserSkill, user_learning_goal_entity_1.UserLearningGoal, skill_entity_1.Skill, swap_request_entity_1.SwapRequest, certificate_entity_1.Certificate])],
        controllers: [feed_controller_1.FeedController],
        providers: [feed_service_1.FeedService],
    })
], FeedModule);
//# sourceMappingURL=feed.module.js.map