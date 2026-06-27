import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'better-sqlite3',
        database: configService.get<string>('database.path'),
        entities: [__dirname + '/../**/*.entity{.ts,.js}'],
        synchronize: true, // auto-sync in dev
      }),
    }),
  ],
})
export class DatabaseModule {}
