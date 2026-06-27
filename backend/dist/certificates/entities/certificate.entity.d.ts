import { User } from '../../users/entities/user.entity';
import { Skill } from '../../skills/entities/skill.entity';
export declare class Certificate {
    id: string;
    userId: string;
    skillId: string | null;
    title: string;
    fileUrl: string;
    fileName: string;
    fileType: string;
    fileSize: number;
    createdAt: Date;
    user: User;
    skill: Skill;
}
