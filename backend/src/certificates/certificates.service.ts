import { Injectable, ForbiddenException, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Certificate } from './entities/certificate.entity';
import { User } from '../users/entities/user.entity';
import { StorageService } from './storage/minio.service';

const ALLOWED_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];
const MAX_FILE_SIZE = 50 * 1024 * 1024; // 50MB

@Injectable()
export class CertificatesService {
  constructor(
    @InjectRepository(Certificate)
    private readonly certRepo: Repository<Certificate>,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    private readonly storageService: StorageService,
  ) {}

  async upload(userId: string, file: Express.Multer.File, title: string, skillId?: string) {
    if (!ALLOWED_TYPES.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type. Allowed: jpg, png, pdf');
    }
    if (file.size > MAX_FILE_SIZE) {
      throw new BadRequestException('File size exceeds 50MB limit');
    }

    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (!user.isPremium) {
      const count = await this.certRepo.count({ where: { userId } });
      if (count >= 1) {
        throw new ForbiddenException('Free users can upload 1 certificate. Upgrade to Premium for unlimited.');
      }
    }

    const { url, fileName } = await this.storageService.uploadFile(file);
    const ext = file.originalname.split('.').pop()?.toLowerCase() || 'unknown';

    const cert = this.certRepo.create({
      userId,
      skillId: skillId || undefined,
      title,
      fileUrl: url,
      fileName,
      fileType: ext,
      fileSize: file.size,
    });

    return this.certRepo.save(cert);
  }

  async getUserCertificates(userId: string) {
    return this.certRepo.find({
      where: { userId },
      relations: { skill: true },
      order: { createdAt: 'DESC' },
    });
  }

  async delete(userId: string, certId: string) {
    const cert = await this.certRepo.findOne({ where: { id: certId, userId } });
    if (!cert) throw new NotFoundException('Certificate not found');
    await this.storageService.deleteFile(cert.fileName);
    await this.certRepo.remove(cert);
    return { message: 'Certificate deleted' };
  }
}
