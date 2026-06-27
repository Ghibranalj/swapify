export declare class CreditCardDetailsDto {
    cardholderName: string;
    cardNumber: string;
    expiryDate: string;
    cvv: string;
    saveCard?: boolean;
}
export declare class EWalletDetailsDto {
    phoneNumber: string;
    provider?: string;
}
export declare class BankTransferDetailsDto {
    bankName: string;
    accountNumber?: string;
    accountHolder?: string;
}
export declare class CreateSubscriptionDto {
    planId: string;
    paymentMethod: string;
    paymentDetails?: CreditCardDetailsDto | EWalletDetailsDto | BankTransferDetailsDto;
}
