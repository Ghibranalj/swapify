"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateSubscriptionDto = exports.BankTransferDetailsDto = exports.EWalletDetailsDto = exports.CreditCardDetailsDto = void 0;
const class_validator_1 = require("class-validator");
const class_transformer_1 = require("class-transformer");
const swagger_1 = require("@nestjs/swagger");
class CreditCardDetailsDto {
    cardholderName;
    cardNumber;
    expiryDate;
    cvv;
    saveCard;
}
exports.CreditCardDetailsDto = CreditCardDetailsDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreditCardDetailsDto.prototype, "cardholderName", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreditCardDetailsDto.prototype, "cardNumber", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreditCardDetailsDto.prototype, "expiryDate", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], CreditCardDetailsDto.prototype, "cvv", void 0);
__decorate([
    (0, swagger_1.ApiPropertyOptional)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsBoolean)(),
    __metadata("design:type", Boolean)
], CreditCardDetailsDto.prototype, "saveCard", void 0);
class EWalletDetailsDto {
    phoneNumber;
    provider;
}
exports.EWalletDetailsDto = EWalletDetailsDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], EWalletDetailsDto.prototype, "phoneNumber", void 0);
__decorate([
    (0, swagger_1.ApiPropertyOptional)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], EWalletDetailsDto.prototype, "provider", void 0);
class BankTransferDetailsDto {
    bankName;
    accountNumber;
    accountHolder;
}
exports.BankTransferDetailsDto = BankTransferDetailsDto;
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], BankTransferDetailsDto.prototype, "bankName", void 0);
__decorate([
    (0, swagger_1.ApiPropertyOptional)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], BankTransferDetailsDto.prototype, "accountNumber", void 0);
__decorate([
    (0, swagger_1.ApiPropertyOptional)(),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], BankTransferDetailsDto.prototype, "accountHolder", void 0);
class CreateSubscriptionDto {
    planId;
    paymentMethod;
    paymentDetails;
}
exports.CreateSubscriptionDto = CreateSubscriptionDto;
__decorate([
    (0, swagger_1.ApiProperty)({ enum: ['monthly', 'yearly'] }),
    (0, class_validator_1.IsIn)(['monthly', 'yearly']),
    __metadata("design:type", String)
], CreateSubscriptionDto.prototype, "planId", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ enum: ['credit_card', 'e_wallet', 'bank_transfer'] }),
    (0, class_validator_1.IsIn)(['credit_card', 'e_wallet', 'bank_transfer']),
    __metadata("design:type", String)
], CreateSubscriptionDto.prototype, "paymentMethod", void 0);
__decorate([
    (0, swagger_1.ApiPropertyOptional)({ description: 'Payment details (varies by method)' }),
    (0, class_validator_1.IsOptional)(),
    (0, class_validator_1.ValidateNested)(),
    (0, class_transformer_1.Type)((opts) => {
        const method = opts?.object?.paymentMethod;
        if (method === 'credit_card')
            return CreditCardDetailsDto;
        if (method === 'e_wallet')
            return EWalletDetailsDto;
        if (method === 'bank_transfer')
            return BankTransferDetailsDto;
        return Object;
    }),
    __metadata("design:type", Object)
], CreateSubscriptionDto.prototype, "paymentDetails", void 0);
//# sourceMappingURL=create-subscription.dto.js.map