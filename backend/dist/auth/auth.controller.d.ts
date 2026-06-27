import { AuthService } from './auth.service';
import { GoogleLoginDto } from './dto/google-login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { User } from '../users/entities/user.entity';
export declare class AuthController {
    private readonly authService;
    constructor(authService: AuthService);
    googleLogin(dto: GoogleLoginDto): Promise<{
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
    refreshToken(dto: RefreshTokenDto): Promise<{
        accessToken: string;
        expiresIn: number | undefined;
    }>;
    logout(user: User): Promise<{
        message: string;
    }>;
}
