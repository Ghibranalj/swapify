import { AdminService } from './admin.service';
import { AdminUpdateUserDto } from './dto/admin-update-user.dto';
import { CreateSkillDto } from '../skills/dto/create-skill.dto';
export declare class AdminController {
    private readonly adminService;
    constructor(adminService: AdminService);
    getUsers(search?: string, page?: string, limit?: string): Promise<{
        users: {
            id: string;
            name: string;
            email: string;
            status: string;
            isPremium: boolean;
            isAdmin: boolean;
            swapCount: number;
            createdAt: Date;
        }[];
        total: number;
        page: number;
        totalPages: number;
    }>;
    updateUser(id: string, dto: AdminUpdateUserDto): Promise<import("../users/entities/user.entity").User>;
    deleteUser(id: string): Promise<{
        message: string;
    }>;
    approveUser(id: string): Promise<import("typeorm").UpdateResult>;
    suspendUser(id: string): Promise<import("typeorm").UpdateResult>;
    restoreUser(id: string): Promise<import("typeorm").UpdateResult>;
    getSkills(search?: string): Promise<import("../skills/entities/skill.entity").Skill[]>;
    createSkill(dto: CreateSkillDto): Promise<import("../skills/entities/skill.entity").Skill>;
    updateSkill(id: string, dto: any): Promise<import("../skills/entities/skill.entity").Skill>;
    deleteSkill(id: string): Promise<{
        message: string;
    }>;
    getStats(): Promise<{
        totalUsers: number;
        totalSkills: number;
        activeRequestCount: number;
        growthPercent: number;
        growthPeriod: string;
    }>;
    getAlerts(page?: string, limit?: string): Promise<{
        alerts: import("../notifications/entities/notification.entity").Notification[];
        total: number;
        page: number;
        totalPages: number;
    }>;
}
