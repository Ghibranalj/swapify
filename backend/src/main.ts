import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import { AppModule } from './app.module';
import { AllExceptionsFilter } from './common/filters/http-exception.filter';
import { seedSkills } from './database/seeds/skill-seeds';
import { seedUsers } from './database/seeds/user-seeds';
import { DataSource } from 'typeorm';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // Enable CORS for Flutter app
  app.enableCors({
    origin: '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Global exception filter
  app.useGlobalFilters(new AllExceptionsFilter());

  // Serve static files (uploaded images, certificates)
  app.useStaticAssets(join(process.cwd(), 'uploads'), {
    prefix: '/uploads/',
  });

  // Swagger API documentation
  const swaggerConfig = new DocumentBuilder()
    .setTitle('Swapify API')
    .setDescription('Backend API for Swapify — Student Skill Exchange Platform')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('Auth', 'Authentication endpoints')
    .addTag('Users', 'User profile management')
    .addTag('Skills', 'Skill catalog and user skills')
    .addTag('Certificates', 'Certificate upload and management')
    .addTag('Feed', 'Discovery and matching')
    .addTag('Swap Requests', 'Skill exchange request lifecycle')
    .addTag('Messages', 'Real-time messaging')
    .addTag('Notifications', 'User notifications')
    .addTag('Subscriptions', 'Premium subscription management')
    .addTag('Admin', 'Admin dashboard and management')
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api/docs', app, document);

  // Seed skills on first run
  const dataSource = app.get(DataSource);
  await seedSkills(dataSource);
  await seedUsers(dataSource);

  const port = process.env.PORT || 3000;
  await app.listen(port);

  console.log(`\n🚀 Swapify API is running on: http://localhost:${port}`);
  console.log(`📚 Swagger Docs: http://localhost:${port}/api/docs`);
  console.log(`🗄️  Database: SQLite (${process.env.DATABASE_PATH || './swapify.db'})\n`);
}

bootstrap();
