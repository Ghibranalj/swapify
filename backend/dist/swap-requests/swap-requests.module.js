"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SwapRequestsModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const swap_requests_service_1 = require("./swap-requests.service");
const swap_requests_controller_1 = require("./swap-requests.controller");
const swap_request_entity_1 = require("./entities/swap-request.entity");
const user_entity_1 = require("../users/entities/user.entity");
const skill_entity_1 = require("../skills/entities/skill.entity");
const notification_entity_1 = require("../notifications/entities/notification.entity");
let SwapRequestsModule = class SwapRequestsModule {
};
exports.SwapRequestsModule = SwapRequestsModule;
exports.SwapRequestsModule = SwapRequestsModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([swap_request_entity_1.SwapRequest, user_entity_1.User, skill_entity_1.Skill, notification_entity_1.Notification])],
        controllers: [swap_requests_controller_1.SwapRequestsController],
        providers: [swap_requests_service_1.SwapRequestsService],
        exports: [swap_requests_service_1.SwapRequestsService],
    })
], SwapRequestsModule);
//# sourceMappingURL=swap-requests.module.js.map