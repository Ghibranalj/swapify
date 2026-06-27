import {
  Controller,
  Get,
  Put,
  Post,
  Param,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiBearerAuth, ApiConsumes, ApiBody } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { UsersService } from './users.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import * as fs from 'fs';
import * as path from 'path';
import { v4 as uuidv4 } from 'uuid';

@ApiTags('Users')
@ApiBearerAuth()
@Controller('users')
export class UsersController {
  private readonly profileUploadDir = path.join(process.cwd(), 'uploads', 'profiles');

  constructor(private readonly usersService: UsersService) {
    if (!fs.existsSync(this.profileUploadDir)) {
      fs.mkdirSync(this.profileUploadDir, { recursive: true });
    }
  }

  /**
   * GET /users/me — Returns the authenticated user's full profile.
   */
  @UseGuards(JwtAuthGuard)
  @Get('me')
  async getMyProfile(@CurrentUser() user: { id: string }) {
    return this.usersService.getProfile(user.id);
  }

  /**
   * PUT /users/me — Updates the authenticated user's profile (name, bio).
   */
  @UseGuards(JwtAuthGuard)
  @Put('me')
  async updateMyProfile(
    @CurrentUser() user: { id: string },
    @Body() dto: UpdateProfileDto,
  ) {
    return this.usersService.updateProfile(user.id, dto);
  }

  /**
   * POST /users/me/profile-image — Uploads a profile image for the authenticated user.
   * The file is saved locally to 'uploads/profiles/'.
   */
  @UseGuards(JwtAuthGuard)
  @Post('me/profile-image')
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  async uploadProfileImage(
    @CurrentUser() user: { id: string },
    @UploadedFile() file: Express.Multer.File,
  ) {
    if (!file) {
      throw new BadRequestException('File is required');
    }

    const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];
    if (!allowedTypes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPG and PNG images are allowed');
    }

    const ext = path.extname(file.originalname);
    const fileName = `${uuidv4()}${ext}`;
    const filePath = path.join(this.profileUploadDir, fileName);
    fs.writeFileSync(filePath, file.buffer);

    const fileUrl = `/uploads/profiles/${fileName}`;
    return this.usersService.uploadProfileImage(user.id, fileUrl);
  }

  /**
   * GET /users/:id — Returns a public profile for any user by ID.
   */
  @UseGuards(JwtAuthGuard)
  @Get(':id')
  async getPublicProfile(@Param('id') id: string) {
    return this.usersService.getPublicProfile(id);
  }
}
