import { Controller, Get, Post, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { SkillsService } from './skills.service';
import { CreateSkillDto } from './dto/create-skill.dto';
import { AddUserSkillDto } from './dto/add-user-skill.dto';
import { AddLearningGoalDto } from './dto/add-learning-goal.dto';

@ApiTags('Skills')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller()
export class SkillsController {
  constructor(private readonly skillsService: SkillsService) {}

  @Get('skills')
  @ApiOperation({ summary: 'List all skills' })
  @ApiQuery({ name: 'category', required: false })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  findAll(
    @Query('category') category?: string,
    @Query('search') search?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.skillsService.findAll({
      category,
      search,
      page: parseInt(page || '', 10) || 1,
      limit: parseInt(limit || '', 10) || 20,
    });
  }

  @Post('skills')
  @ApiOperation({ summary: 'Create a custom skill' })
  create(@Body() dto: CreateSkillDto) {
    return this.skillsService.create(dto);
  }

  @Get('users/me/skills')
  @ApiOperation({ summary: 'Get my skills' })
  getUserSkills(@CurrentUser() user: User) {
    return this.skillsService.getUserSkills(user.id);
  }

  @Post('users/me/skills')
  @ApiOperation({ summary: 'Add a skill to my profile' })
  addUserSkill(@CurrentUser() user: User, @Body() dto: AddUserSkillDto) {
    return this.skillsService.addUserSkill(user.id, dto);
  }

  @Delete('users/me/skills/:id')
  @ApiOperation({ summary: 'Remove a skill from my profile' })
  removeUserSkill(@CurrentUser() user: User, @Param('id') id: string) {
    return this.skillsService.removeUserSkill(user.id, id);
  }

  @Get('users/me/learning-goals')
  @ApiOperation({ summary: 'Get my learning goals' })
  getLearningGoals(@CurrentUser() user: User) {
    return this.skillsService.getLearningGoals(user.id);
  }

  @Post('users/me/learning-goals')
  @ApiOperation({ summary: 'Add a learning goal' })
  addLearningGoal(@CurrentUser() user: User, @Body() dto: AddLearningGoalDto) {
    return this.skillsService.addLearningGoal(user.id, dto);
  }

  @Delete('users/me/learning-goals/:id')
  @ApiOperation({ summary: 'Remove a learning goal' })
  removeLearningGoal(@CurrentUser() user: User, @Param('id') id: string) {
    return this.skillsService.removeLearningGoal(user.id, id);
  }
}
