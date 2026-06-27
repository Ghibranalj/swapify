import { Controller, Get, Post, Delete, Param, Body, UseGuards, UseInterceptors, UploadedFile } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiBearerAuth, ApiOperation, ApiConsumes } from '@nestjs/swagger';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { CertificatesService } from './certificates.service';
import { UploadCertificateDto } from './dto/upload-certificate.dto';

@ApiTags('Certificates')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('certificates')
export class CertificatesController {
  constructor(private readonly certificatesService: CertificatesService) {}

  @Post('upload')
  @ApiOperation({ summary: 'Upload a certificate' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  upload(
    @CurrentUser() user: User,
    @UploadedFile() file: Express.Multer.File,
    @Body() dto: UploadCertificateDto,
  ) {
    return this.certificatesService.upload(user.id, file, dto.title, dto.skillId);
  }

  @Get('me')
  @ApiOperation({ summary: 'Get my certificates' })
  getMyCertificates(@CurrentUser() user: User) {
    return this.certificatesService.getUserCertificates(user.id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete a certificate' })
  delete(@CurrentUser() user: User, @Param('id') id: string) {
    return this.certificatesService.delete(user.id, id);
  }
}
