import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { SubscriptionsService } from './subscriptions.service';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';

@ApiTags('Subscriptions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('subscriptions')
export class SubscriptionsController {
  constructor(private readonly subsService: SubscriptionsService) {}

  @Get('plans')
  @ApiOperation({ summary: 'Get subscription plans' })
  getPlans() { return this.subsService.getPlans(); }

  @Post()
  @ApiOperation({ summary: 'Subscribe to premium' })
  subscribe(@CurrentUser() user: User, @Body() dto: CreateSubscriptionDto) { return this.subsService.subscribe(user.id, dto); }

  @Get('me')
  @ApiOperation({ summary: 'Get my subscription' })
  getMySubscription(@CurrentUser() user: User) { return this.subsService.getMySubscription(user.id); }

  @Post('cancel')
  @ApiOperation({ summary: 'Cancel subscription' })
  cancel(@CurrentUser() user: User) { return this.subsService.cancel(user.id); }
}
