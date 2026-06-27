import { User } from '../../users/entities/user.entity';
import { Skill } from '../../skills/entities/skill.entity';
export declare class SwapRequest {
    id: string;
    requesterId: string;
    providerId: string;
    requesterSkillId: string;
    providerSkillId: string;
    message: string | null;
    status: string;
    rating: number | null;
    ratingComment: string | null;
    ratedAt: Date | null;
    createdAt: Date;
    updatedAt: Date;
    requester: User;
    provider: User;
    requesterSkill: Skill;
    providerSkill: Skill;
}
