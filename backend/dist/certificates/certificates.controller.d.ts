import { User } from '../users/entities/user.entity';
import { CertificatesService } from './certificates.service';
import { UploadCertificateDto } from './dto/upload-certificate.dto';
export declare class CertificatesController {
    private readonly certificatesService;
    constructor(certificatesService: CertificatesService);
    upload(user: User, file: Express.Multer.File, dto: UploadCertificateDto): Promise<import("./entities/certificate.entity").Certificate>;
    getMyCertificates(user: User): Promise<import("./entities/certificate.entity").Certificate[]>;
    delete(user: User, id: string): Promise<{
        message: string;
    }>;
}
