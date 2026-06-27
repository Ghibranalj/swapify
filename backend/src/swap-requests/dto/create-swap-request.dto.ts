import { IsUUID, IsOptional, IsString, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateSwapRequestDto {
  @ApiProperty({ description: 'Target user ID (provider)' })
  @IsUUID()
  providerId: string;

  @ApiProperty({ description: 'Skill the requester offers to teach' })
  @IsUUID()
  requesterSkillId: string;

  @ApiProperty({ description: 'Skill the requester wants to learn' })
  @IsUUID()
  providerSkillId: string;

  @ApiPropertyOptional({ description: 'Optional message' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  message?: string;
}
