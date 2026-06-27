import { UserSkill } from '../../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../../skills/entities/user-learning-goal.entity';
import { Certificate } from '../../certificates/entities/certificate.entity';
export declare class User {
    id: string;
    name: string;
    bio: string;
    profileImageUrl: string;
    email: string;
    googleId: string;
    isPremium: boolean;
    premiumExpiresAt: Date | null;
    swapCount: number;
    isAdmin: boolean;
    refreshToken: string;
    status: string;
    createdAt: Date;
    updatedAt: Date;
    skills: UserSkill[];
    learningGoals: UserLearningGoal[];
    certificates: Certificate[];
}
