import { User } from '../../users/entities/user.entity';
import { Skill } from './skill.entity';
export declare class UserLearningGoal {
    id: string;
    userId: string;
    skillId: string;
    priority: number;
    createdAt: Date;
    user: User;
    skill: Skill;
}
