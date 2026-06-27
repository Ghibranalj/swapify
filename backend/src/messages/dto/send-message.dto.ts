import { IsString, IsNotEmpty, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SendMessageDto {
  @ApiProperty({ example: 'Hey, when can we meet for the swap?' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(2000)
  content: string;
}
