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
exports.SwapRequestsController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const jwt_auth_guard_1 = require("../common/guards/jwt-auth.guard");
const current_user_decorator_1 = require("../common/decorators/current-user.decorator");
const user_entity_1 = require("../users/entities/user.entity");
const swap_requests_service_1 = require("./swap-requests.service");
const create_swap_request_dto_1 = require("./dto/create-swap-request.dto");
const rate_swap_dto_1 = require("./dto/rate-swap.dto");
let SwapRequestsController = class SwapRequestsController {
    swapService;
    constructor(swapService) {
        this.swapService = swapService;
    }
    create(user, dto) {
        return this.swapService.create(user.id, dto);
    }
    findAll(user, status, direction, page, limit) {
        return this.swapService.findAll(user.id, { status, direction, page: parseInt(page || '', 10) || 1, limit: parseInt(limit || '', 10) || 20 });
    }
    findOne(user, id) {
        return this.swapService.findOne(id, user.id);
    }
    accept(user, id) {
        return this.swapService.accept(id, user.id);
    }
    decline(user, id) {
        return this.swapService.decline(id, user.id);
    }
    cancel(user, id) {
        return this.swapService.cancel(id, user.id);
    }
    complete(user, id) {
        return this.swapService.complete(id, user.id);
    }
    rate(user, id, dto) {
        return this.swapService.rate(id, user.id, dto);
    }
};
exports.SwapRequestsController = SwapRequestsController;
__decorate([
    (0, common_1.Post)(),
    (0, swagger_1.ApiOperation)({ summary: 'Create a swap request' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, create_swap_request_dto_1.CreateSwapRequestDto]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "create", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'List my swap requests' }),
    (0, swagger_1.ApiQuery)({ name: 'status', required: false, enum: ['pending', 'active', 'done', 'cancelled'] }),
    (0, swagger_1.ApiQuery)({ name: 'direction', required: false, enum: ['sent', 'received'] }),
    (0, swagger_1.ApiQuery)({ name: 'page', required: false, type: Number }),
    (0, swagger_1.ApiQuery)({ name: 'limit', required: false, type: Number }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Query)('status')),
    __param(2, (0, common_1.Query)('direction')),
    __param(3, (0, common_1.Query)('page')),
    __param(4, (0, common_1.Query)('limit')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String, String, String, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    (0, swagger_1.ApiOperation)({ summary: 'Get swap request details' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "findOne", null);
__decorate([
    (0, common_1.Put)(':id/accept'),
    (0, swagger_1.ApiOperation)({ summary: 'Accept a swap request' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "accept", null);
__decorate([
    (0, common_1.Put)(':id/decline'),
    (0, swagger_1.ApiOperation)({ summary: 'Decline a swap request' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "decline", null);
__decorate([
    (0, common_1.Put)(':id/cancel'),
    (0, swagger_1.ApiOperation)({ summary: 'Cancel a swap request' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "cancel", null);
__decorate([
    (0, common_1.Put)(':id/complete'),
    (0, swagger_1.ApiOperation)({ summary: 'Mark swap as complete' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "complete", null);
__decorate([
    (0, common_1.Post)(':id/rate'),
    (0, swagger_1.ApiOperation)({ summary: 'Rate a completed swap' }),
    __param(0, (0, current_user_decorator_1.CurrentUser)()),
    __param(1, (0, common_1.Param)('id')),
    __param(2, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [user_entity_1.User, String, rate_swap_dto_1.RateSwapDto]),
    __metadata("design:returntype", void 0)
], SwapRequestsController.prototype, "rate", null);
exports.SwapRequestsController = SwapRequestsController = __decorate([
    (0, swagger_1.ApiTags)('Swap Requests'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    (0, common_1.Controller)('swap-requests'),
    __metadata("design:paramtypes", [swap_requests_service_1.SwapRequestsService])
], SwapRequestsController);
//# sourceMappingURL=swap-requests.controller.js.map