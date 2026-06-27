import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import configuration from './config/configuration';
import { DatabaseModule } from './database/database.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { SkillsModule } from './skills/skills.module';
import { CertificatesModule } from './certificates/certificates.module';
import { FeedModule } from './feed/feed.module';
import { SwapRequestsModule } from './swap-requests/swap-requests.module';
import { MessagesModule } from './messages/messages.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SubscriptionsModule } from './subscriptions/subscriptions.module';
import { AdminModule } from './admin/admin.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    DatabaseModule,
    AuthModule,
    UsersModule,
    SkillsModule,
    CertificatesModule,
    FeedModule,
    SwapRequestsModule,
    MessagesModule,
    NotificationsModule,
    SubscriptionsModule,
    AdminModule,
  ],
})
export class AppModule {}
