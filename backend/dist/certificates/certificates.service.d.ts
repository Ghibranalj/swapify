import { Repository } from 'typeorm';
import { Certificate } from './entities/certificate.entity';
import { User } from '../users/entities/user.entity';
import { StorageService } from './storage/minio.service';
export declare class CertificatesService {
    private readonly certRepo;
    private readonly userRepo;
    private readonly storageService;
    constructor(certRepo: Repository<Certificate>, userRepo: Repository<User>, storageService: StorageService);
    upload(userId: string, file: Express.Multer.File, title: string, skillId?: string): Promise<Certificate>;
    getUserCertificates(userId: string): Promise<Certificate[]>;
    delete(userId: string, certId: string): Promise<{
        message: string;
    }>;
}
