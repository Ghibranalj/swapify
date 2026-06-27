import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
export declare class AuthService {
    private readonly usersRepository;
    private readonly jwtService;
    private readonly configService;
    private googleClient;
    constructor(usersRepository: Repository<User>, jwtService: JwtService, configService: ConfigService);
    googleLogin(idToken: string): Promise<{
        accessToken: string;
        refreshToken: string;
        expiresIn: number | undefined;
        user: {
            id: string;
            name: string;
            bio: string;
            email: string;
            profileImageUrl: string;
            isPremium: boolean;
        };
    }>;
    refreshAccessToken(refreshToken: string): Promise<{
        accessToken: string;
        expiresIn: number | undefined;
    }>;
    logout(userId: string): Promise<{
        message: string;
    }>;
    private generateAccessToken;
}
