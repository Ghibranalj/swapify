import { Controller, Get, Post, Put, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiQuery } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { SwapRequestsService } from './swap-requests.service';
import { CreateSwapRequestDto } from './dto/create-swap-request.dto';
import { RateSwapDto } from './dto/rate-swap.dto';

@ApiTags('Swap Requests')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('swap-requests')
export class SwapRequestsController {
  constructor(private readonly swapService: SwapRequestsService) {}

  @Post()
  @ApiOperation({ summary: 'Create a swap request' })
  create(@CurrentUser() user: User, @Body() dto: CreateSwapRequestDto) {
    return this.swapService.create(user.id, dto);
  }

  @Get()
  @ApiOperation({ summary: 'List my swap requests' })
  @ApiQuery({ name: 'status', required: false, enum: ['pending', 'active', 'done', 'cancelled'] })
  @ApiQuery({ name: 'direction', required: false, enum: ['sent', 'received'] })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  findAll(@CurrentUser() user: User, @Query('status') status?: string, @Query('direction') direction?: string, @Query('page') page?: string, @Query('limit') limit?: string) {
    return this.swapService.findAll(user.id, { status, direction, page: parseInt(page || '', 10) || 1, limit: parseInt(limit || '', 10) || 20 });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get swap request details' })
  findOne(@CurrentUser() user: User, @Param('id') id: string) {
    return this.swapService.findOne(id, user.id);
  }

  @Put(':id/accept')
  @ApiOperation({ summary: 'Accept a swap request' })
  accept(@CurrentUser() user: User, @Param('id') id: string) {
    return this.swapService.accept(id, user.id);
  }

  @Put(':id/decline')
  @ApiOperation({ summary: 'Decline a swap request' })
  decline(@CurrentUser() user: User, @Param('id') id: string) {
    return this.swapService.decline(id, user.id);
  }

  @Put(':id/cancel')
  @ApiOperation({ summary: 'Cancel a swap request' })
  cancel(@CurrentUser() user: User, @Param('id') id: string) {
    return this.swapService.cancel(id, user.id);
  }

  @Put(':id/complete')
  @ApiOperation({ summary: 'Mark swap as complete' })
  complete(@CurrentUser() user: User, @Param('id') id: string) {
    return this.swapService.complete(id, user.id);
  }

  @Post(':id/rate')
  @ApiOperation({ summary: 'Rate a completed swap' })
  rate(@CurrentUser() user: User, @Param('id') id: string, @Body() dto: RateSwapDto) {
    return this.swapService.rate(id, user.id, dto);
  }
}
