import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('subscriptions')
export class Subscription {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  userId: string;

  @Column()
  plan: string; // 'monthly' | 'yearly'

  @Column({ type: 'integer' })
  price: number; // in Rupiah

  @Column()
  paymentMethod: string; // 'credit_card' | 'e_wallet' | 'bank_transfer'

  @Column({ default: 'active' })
  status: string; // 'active' | 'cancelled' | 'expired'

  @Column({ type: 'datetime' })
  startsAt: Date;

  @Column({ type: 'datetime' })
  expiresAt: Date;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user: User;
}
