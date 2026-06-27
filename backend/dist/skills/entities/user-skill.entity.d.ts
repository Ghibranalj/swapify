import { User } from '../../users/entities/user.entity';
import { Skill } from './skill.entity';
export declare class UserSkill {
    id: string;
    userId: string;
    skillId: string;
    proficiency: number;
    createdAt: Date;
    user: User;
    skill: Skill;
}
