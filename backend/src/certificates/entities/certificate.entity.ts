import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Skill } from '../../skills/entities/skill.entity';

@Entity('certificates')
export class Certificate {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column({ type: 'varchar', nullable: true })
  skillId: string | null;

  @Column()
  title: string;

  @Column()
  fileUrl: string;

  @Column()
  fileName: string;

  @Column()
  fileType: string; // jpg, png, pdf

  @Column({ type: 'integer' })
  fileSize: number; // bytes

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, (u) => u.certificates, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;

  @ManyToOne(() => Skill, { nullable: true, eager: true })
  @JoinColumn({ name: 'skillId' })
  skill: Skill;
}
