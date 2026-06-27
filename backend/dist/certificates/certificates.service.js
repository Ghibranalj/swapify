"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CertificatesService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const certificate_entity_1 = require("./entities/certificate.entity");
const user_entity_1 = require("../users/entities/user.entity");
const minio_service_1 = require("./storage/minio.service");
const ALLOWED_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf'];
const MAX_FILE_SIZE = 50 * 1024 * 1024;
let CertificatesService = class CertificatesService {
    certRepo;
    userRepo;
    storageService;
    constructor(certRepo, userRepo, storageService) {
        this.certRepo = certRepo;
        this.userRepo = userRepo;
        this.storageService = storageService;
    }
    async upload(userId, file, title, skillId) {
        if (!ALLOWED_TYPES.includes(file.mimetype)) {
            throw new common_1.BadRequestException('Invalid file type. Allowed: jpg, png, pdf');
        }
        if (file.size > MAX_FILE_SIZE) {
            throw new common_1.BadRequestException('File size exceeds 50MB limit');
        }
        const user = await this.userRepo.findOne({ where: { id: userId } });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.isPremium) {
            const count = await this.certRepo.count({ where: { userId } });
            if (count >= 1) {
                throw new common_1.ForbiddenException('Free users can upload 1 certificate. Upgrade to Premium for unlimited.');
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
    async getUserCertificates(userId) {
        return this.certRepo.find({
            where: { userId },
            relations: { skill: true },
            order: { createdAt: 'DESC' },
        });
    }
    async delete(userId, certId) {
        const cert = await this.certRepo.findOne({ where: { id: certId, userId } });
        if (!cert)
            throw new common_1.NotFoundException('Certificate not found');
        await this.storageService.deleteFile(cert.fileName);
        await this.certRepo.remove(cert);
        return { message: 'Certificate deleted' };
    }
};
exports.CertificatesService = CertificatesService;
exports.CertificatesService = CertificatesService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(certificate_entity_1.Certificate)),
    __param(1, (0, typeorm_1.InjectRepository)(user_entity_1.User)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository,
        minio_service_1.StorageService])
], CertificatesService);
//# sourceMappingURL=certificates.service.js.map