import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SwapRequestsService } from './swap-requests.service';
import { SwapRequestsController } from './swap-requests.controller';
import { SwapRequest } from './entities/swap-request.entity';
import { User } from '../users/entities/user.entity';
import { Skill } from '../skills/entities/skill.entity';
import { Notification } from '../notifications/entities/notification.entity';

@Module({
  imports: [TypeOrmModule.forFeature([SwapRequest, User, Skill, Notification])],
  controllers: [SwapRequestsController],
  providers: [SwapRequestsService],
  exports: [SwapRequestsService],
})
export class SwapRequestsModule {}
