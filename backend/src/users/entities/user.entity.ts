import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { UserSkill } from '../../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../../skills/entities/user-learning-goal.entity';
import { Certificate } from '../../certificates/entities/certificate.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true, default: '' })
  bio: string;

  @Column({ nullable: true })
  profileImageUrl: string;

  @Column({ unique: true })
  email: string;

  @Column({ unique: true })
  googleId: string;

  @Column({ default: false })
  isPremium: boolean;

  @Column({ type: 'datetime', nullable: true })
  premiumExpiresAt: Date | null;

  @Column({ default: 0 })
  swapCount: number;

  @Column({ default: false })
  isAdmin: boolean;

  @Column({ nullable: true })
  refreshToken: string;

  @Column({ default: 'active' })
  status: string; // 'active' | 'pending' | 'suspended'

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => UserSkill, (us) => us.user, { eager: false })
  skills: UserSkill[];

  @OneToMany(() => UserLearningGoal, (g) => g.user, { eager: false })
  learningGoals: UserLearningGoal[];

  @OneToMany(() => Certificate, (c) => c.user, { eager: false })
  certificates: Certificate[];
}
