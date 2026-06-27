import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { AdminGuard } from '../common/guards/admin.guard';
import { AdminService } from './admin.service';
import { AdminUpdateUserDto } from './dto/admin-update-user.dto';
import { CreateSkillDto } from '../skills/dto/create-skill.dto';

@ApiTags('Admin')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, AdminGuard)
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('users') @ApiOperation({ summary: 'List users' })
  getUsers(@Query('search') search?: string, @Query('page') page?: string, @Query('limit') limit?: string) {
    return this.adminService.getUsers({ search, page: parseInt(page || '') || 1, limit: parseInt(limit || '') || 10 });
  }

  @Put('users/:id') @ApiOperation({ summary: 'Update user' })
  updateUser(@Param('id') id: string, @Body() dto: AdminUpdateUserDto) { return this.adminService.updateUser(id, dto); }

  @Delete('users/:id') @ApiOperation({ summary: 'Delete user' })
  deleteUser(@Param('id') id: string) { return this.adminService.deleteUser(id); }

  @Put('users/:id/approve') @ApiOperation({ summary: 'Approve user' })
  approveUser(@Param('id') id: string) { return this.adminService.approveUser(id); }

  @Put('users/:id/suspend') @ApiOperation({ summary: 'Suspend user' })
  suspendUser(@Param('id') id: string) { return this.adminService.suspendUser(id); }

  @Put('users/:id/restore') @ApiOperation({ summary: 'Restore user' })
  restoreUser(@Param('id') id: string) { return this.adminService.restoreUser(id); }

  @Get('skills') @ApiOperation({ summary: 'List skills' })
  getSkills(@Query('search') search?: string) { return this.adminService.getSkills({ search }); }

  @Post('skills') @ApiOperation({ summary: 'Create skill' })
  createSkill(@Body() dto: CreateSkillDto) { return this.adminService.createSkill(dto); }

  @Put('skills/:id') @ApiOperation({ summary: 'Update skill' })
  updateSkill(@Param('id') id: string, @Body() dto: any) { return this.adminService.updateSkill(id, dto); }

  @Delete('skills/:id') @ApiOperation({ summary: 'Delete skill' })
  deleteSkill(@Param('id') id: string) { return this.adminService.deleteSkill(id); }

  @Get('stats') @ApiOperation({ summary: 'Dashboard stats' })
  getStats() { return this.adminService.getStats(); }

  @Get('alerts') @ApiOperation({ summary: 'Admin alerts' })
  getAlerts(@Query('page') page?: string, @Query('limit') limit?: string) { return this.adminService.getAlerts({ page: parseInt(page || '') || 1, limit: parseInt(limit || '') || 20 }); }
}
