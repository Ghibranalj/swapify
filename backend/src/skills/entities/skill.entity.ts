import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('skills')
export class Skill {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  name: string;

  @Column()
  category: string; // 'Design' | 'Coding' | 'Language' | 'Music' | 'Art'

  @Column({ default: false })
  isUserCreated: boolean;

  @CreateDateColumn()
  createdAt: Date;
}
