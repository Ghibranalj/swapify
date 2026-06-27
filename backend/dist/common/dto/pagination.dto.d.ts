export declare class PaginationDto {
    page?: number;
    limit?: number;
}
export declare class PaginatedResponse<T> {
    data: T[];
    page: number;
    totalPages: number;
    total: number;
    constructor(data: T[], total: number, page: number, limit: number);
}
