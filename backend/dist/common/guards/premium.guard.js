"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PremiumGuard = void 0;
const common_1 = require("@nestjs/common");
let PremiumGuard = class PremiumGuard {
    canActivate(context) {
        const request = context.switchToHttp().getRequest();
        const user = request.user;
        if (!user?.isPremium || (user.premiumExpiresAt && new Date(user.premiumExpiresAt) < new Date())) {
            throw new common_1.ForbiddenException('This feature requires a Premium subscription');
        }
        return true;
    }
};
exports.PremiumGuard = PremiumGuard;
exports.PremiumGuard = PremiumGuard = __decorate([
    (0, common_1.Injectable)()
], PremiumGuard);
//# sourceMappingURL=premium.guard.js.map