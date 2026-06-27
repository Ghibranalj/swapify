"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const path_1 = require("path");
const app_module_1 = require("./app.module");
const http_exception_filter_1 = require("./common/filters/http-exception.filter");
const skill_seeds_1 = require("./database/seeds/skill-seeds");
const user_seeds_1 = require("./database/seeds/user-seeds");
const typeorm_1 = require("typeorm");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    app.enableCors({
        origin: '*',
        methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
        credentials: true,
    });
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }));
    app.useGlobalFilters(new http_exception_filter_1.AllExceptionsFilter());
    app.useStaticAssets((0, path_1.join)(process.cwd(), 'uploads'), {
        prefix: '/uploads/',
    });
    const swaggerConfig = new swagger_1.DocumentBuilder()
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
    const document = swagger_1.SwaggerModule.createDocument(app, swaggerConfig);
    swagger_1.SwaggerModule.setup('api/docs', app, document);
    const dataSource = app.get(typeorm_1.DataSource);
    await (0, skill_seeds_1.seedSkills)(dataSource);
    await (0, user_seeds_1.seedUsers)(dataSource);
    const port = process.env.PORT || 3000;
    await app.listen(port);
    console.log(`\n🚀 Swapify API is running on: http://localhost:${port}`);
    console.log(`📚 Swagger Docs: http://localhost:${port}/api/docs`);
    console.log(`🗄️  Database: SQLite (${process.env.DATABASE_PATH || './swapify.db'})\n`);
}
bootstrap();
//# sourceMappingURL=main.js.map