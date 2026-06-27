import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';
import { UserSkill } from '../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../skills/entities/user-learning-goal.entity';
import { Certificate } from '../certificates/entities/certificate.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, UserSkill, UserLearningGoal, Certificate, SwapRequest])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
