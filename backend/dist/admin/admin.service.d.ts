import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { Skill } from '../skills/entities/skill.entity';
import { SwapRequest } from '../swap-requests/entities/swap-request.entity';
import { Notification } from '../notifications/entities/notification.entity';
export declare class AdminService {
    private userRepo;
    private skillRepo;
    private swapRepo;
    private notifRepo;
    constructor(userRepo: Repository<User>, skillRepo: Repository<Skill>, swapRepo: Repository<SwapRequest>, notifRepo: Repository<Notification>);
    getUsers(query?: {
        search?: string;
        page?: number;
        limit?: number;
    }): Promise<{
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
    updateUser(id: string, data: any): Promise<User>;
    deleteUser(id: string): Promise<{
        message: string;
    }>;
    approveUser(id: string): Promise<import("typeorm").UpdateResult>;
    suspendUser(id: string): Promise<import("typeorm").UpdateResult>;
    restoreUser(id: string): Promise<import("typeorm").UpdateResult>;
    getSkills(query?: {
        search?: string;
    }): Promise<Skill[]>;
    createSkill(dto: {
        name: string;
        category: string;
    }): Promise<Skill>;
    updateSkill(id: string, dto: any): Promise<Skill>;
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
    getAlerts(query?: {
        page?: number;
        limit?: number;
    }): Promise<{
        alerts: Notification[];
        total: number;
        page: number;
        totalPages: number;
    }>;
}
