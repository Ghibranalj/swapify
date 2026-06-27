import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Unique,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Skill } from './skill.entity';

@Entity('user_learning_goals')
@Unique(['userId', 'skillId'])
export class UserLearningGoal {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column()
  skillId: string;

  @Column({ type: 'integer', nullable: true })
  priority: number; // 1-5

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, (u) => u.learningGoals, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;

  @ManyToOne(() => Skill, { eager: true, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
