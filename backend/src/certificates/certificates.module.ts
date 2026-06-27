import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CertificatesService } from './certificates.service';
import { CertificatesController } from './certificates.controller';
import { Certificate } from './entities/certificate.entity';
import { User } from '../users/entities/user.entity';
import { StorageService } from './storage/minio.service';

@Module({
  imports: [TypeOrmModule.forFeature([Certificate, User])],
  controllers: [CertificatesController],
  providers: [CertificatesService, StorageService],
  exports: [CertificatesService],
})
export class CertificatesModule {}
