import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeedService } from './feed.service';
import { FeedController } from './feed.controller';
import { User } from '../users/entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Skill } from '../skills/entities/skill.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { Certificate } from '../certificates/entities/certificate.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserSkill, UserLearningGoal, Skill, SwapRequest, Certificate])],
  controllers: [FeedController],
  providers: [FeedService],
})
export class FeedModule {}
