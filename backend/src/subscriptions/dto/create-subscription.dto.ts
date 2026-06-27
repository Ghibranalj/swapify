import {
  IsString,
  IsIn,
  ValidateNested,
  IsOptional,
  IsBoolean,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreditCardDetailsDto {
  @ApiProperty()
  @IsString()
  cardholderName: string;

  @ApiProperty()
  @IsString()
  cardNumber: string;

  @ApiProperty()
  @IsString()
  expiryDate: string;

  @ApiProperty()
  @IsString()
  cvv: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  saveCard?: boolean;
}

export class EWalletDetailsDto {
  @ApiProperty()
  @IsString()
  phoneNumber: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  provider?: string;
}

export class BankTransferDetailsDto {
  @ApiProperty()
  @IsString()
  bankName: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  accountNumber?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  accountHolder?: string;
}

export class CreateSubscriptionDto {
  @ApiProperty({ enum: ['monthly', 'yearly'] })
  @IsIn(['monthly', 'yearly'])
  planId: string;

  @ApiProperty({ enum: ['credit_card', 'e_wallet', 'bank_transfer'] })
  @IsIn(['credit_card', 'e_wallet', 'bank_transfer'])
  paymentMethod: string;

  @ApiPropertyOptional({ description: 'Payment details (varies by method)' })
  @IsOptional()
  @ValidateNested()
  @Type((opts) => {
    const method = opts?.object?.paymentMethod;
    if (method === 'credit_card') return CreditCardDetailsDto;
    if (method === 'e_wallet') return EWalletDetailsDto;
    if (method === 'bank_transfer') return BankTransferDetailsDto;
    return Object;
  })
  paymentDetails?:
    | CreditCardDetailsDto
    | EWalletDetailsDto
    | BankTransferDetailsDto;
}
