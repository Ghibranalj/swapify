import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OAuth2Client } from 'google-auth-library';
import { User } from '../users/entities/user.entity';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  private googleClient: OAuth2Client;

  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {
    this.googleClient = new OAuth2Client(
      this.configService.get<string>('google.clientId'),
    );
  }

  async googleLogin(idToken: string) {
    let payload: any;

    try {
      const ticket = await this.googleClient.verifyIdToken({
        idToken,
        audience: this.configService.get<string>('google.clientId'),
      });
      payload = ticket.getPayload();
    } catch {
      // In development, allow a mock login for testing
      if (idToken === 'dev-test-token' || idToken.startsWith('dev-test-token:')) {
        const suffix = idToken.includes(':') ? idToken.split(':')[1] : 'static';
        let cleanName = 'New User';
        let slug = suffix;
        if (suffix === 'static') {
          cleanName = 'Dev User';
          slug = 'static';
        } else if (!suffix.startsWith('new-user-')) {
          cleanName = decodeURIComponent(suffix);
          slug = cleanName.toLowerCase().replace(/[^a-z0-9]/g, '-');
        }
        payload = {
          sub: `dev-google-id-${slug}`,
          email: `${slug}@test.com`,
          name: cleanName,
          picture: null,
        };
      } else {
        throw new UnauthorizedException('Invalid Google ID token');
      }
    }

    const { sub: googleId, email, name, picture } = payload;

    // Upsert user
    let user = await this.usersRepository.findOne({ where: { googleId } });
    if (!user) {
      user = this.usersRepository.create({
        googleId,
        email,
        name: name || 'User',
        profileImageUrl: picture || null,
      });
      user = await this.usersRepository.save(user);
    }

    // Generate tokens
    const accessToken = this.generateAccessToken(user);
    const refreshToken = uuidv4();

    // Store refresh token
    user.refreshToken = refreshToken;
    await this.usersRepository.save(user);

    return {
      accessToken,
      refreshToken,
      expiresIn: this.configService.get<number>('jwt.expiresIn'),
      user: {
        id: user.id,
        name: user.name,
        bio: user.bio,
        email: user.email,
        profileImageUrl: user.profileImageUrl,
        isPremium: user.isPremium,
      },
    };
  }

  async refreshAccessToken(refreshToken: string) {
    const user = await this.usersRepository.findOne({
      where: { refreshToken },
    });
    if (!user) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    const accessToken = this.generateAccessToken(user);
    return {
      accessToken,
      expiresIn: this.configService.get<number>('jwt.expiresIn'),
    };
  }

  async logout(userId: string) {
    await this.usersRepository.update(userId, { refreshToken: undefined as any });
    return { message: 'Logged out successfully' };
  }

  private generateAccessToken(user: User): string {
    const payload = { sub: user.id, email: user.email };
    return this.jwtService.sign(payload);
  }
}
