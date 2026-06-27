import { IsString, IsNotEmpty, IsIn, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateSkillDto {
  @ApiProperty({ example: 'React Native' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @ApiProperty({ example: 'Coding', enum: ['Design', 'Coding', 'Language', 'Music', 'Art'] })
  @IsString()
  @IsIn(['Design', 'Coding', 'Language', 'Music', 'Art'])
  category: string;
}
