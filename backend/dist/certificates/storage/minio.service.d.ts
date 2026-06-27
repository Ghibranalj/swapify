export declare class StorageService {
    private readonly uploadDir;
    constructor();
    uploadFile(file: Express.Multer.File): Promise<{
        url: string;
        fileName: string;
    }>;
    deleteFile(fileName: string): Promise<void>;
}
