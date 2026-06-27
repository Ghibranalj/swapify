import { Controller, Get, Post, Put, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { MessagesService } from './messages.service';
import { SendMessageDto } from './dto/send-message.dto';

@ApiTags('Messages')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Get('threads')
  @ApiOperation({ summary: 'Get conversation threads' })
  getThreads(@CurrentUser() user: User) {
    return this.messagesService.getThreads(user.id);
  }

  @Get(':swapRequestId')
  @ApiOperation({ summary: 'Get messages for a conversation' })
  getMessages(@CurrentUser() user: User, @Param('swapRequestId') swapRequestId: string, @Query('before') before?: string, @Query('limit') limit?: string) {
    return this.messagesService.getMessages(swapRequestId, user.id, { before, limit: parseInt(limit || '') || 50 });
  }

  @Post(':swapRequestId')
  @ApiOperation({ summary: 'Send a message' })
  sendMessage(@CurrentUser() user: User, @Param('swapRequestId') swapRequestId: string, @Body() dto: SendMessageDto) {
    return this.messagesService.sendMessage(swapRequestId, user.id, dto);
  }

  @Put(':id/read')
  @ApiOperation({ summary: 'Mark message as read' })
  markAsRead(@CurrentUser() user: User, @Param('id') id: string) {
    return this.messagesService.markAsRead(id, user.id);
  }

  @Put('threads/:swapRequestId/read-all')
  @ApiOperation({ summary: 'Mark all messages in thread as read' })
  markAllRead(@CurrentUser() user: User, @Param('swapRequestId') swapRequestId: string) {
    return this.messagesService.markAllThreadAsRead(swapRequestId, user.id);
  }
}
