import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Skill } from '../../skills/entities/skill.entity';

@Entity('swap_requests')
export class SwapRequest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  requesterId: string;

  @Column()
  providerId: string;

  @Column()
  requesterSkillId: string;

  @Column()
  providerSkillId: string;

  @Column({ type: 'varchar', nullable: true })
  message: string | null;

  @Column({ default: 'pending' })
  status: string; // 'pending' | 'active' | 'done' | 'cancelled'

  @Column({ type: 'integer', nullable: true })
  rating: number | null; // 1-5

  @Column({ type: 'varchar', nullable: true })
  ratingComment: string | null;

  @Column({ type: 'datetime', nullable: true })
  ratedAt: Date | null;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @ManyToOne(() => User, { eager: true })
  @JoinColumn({ name: 'requesterId' })
  requester: User;

  @ManyToOne(() => User, { eager: true })
  @JoinColumn({ name: 'providerId' })
  provider: User;

  @ManyToOne(() => Skill, { eager: true })
  @JoinColumn({ name: 'requesterSkillId' })
  requesterSkill: Skill;

  @ManyToOne(() => Skill, { eager: true })
  @JoinColumn({ name: 'providerSkillId' })
  providerSkill: Skill;
}
