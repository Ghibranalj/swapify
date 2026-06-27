import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';

@Injectable()
export class PremiumGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user?.isPremium || (user.premiumExpiresAt && new Date(user.premiumExpiresAt) < new Date())) {
      throw new ForbiddenException('This feature requires a Premium subscription');
    }
    return true;
  }
}
