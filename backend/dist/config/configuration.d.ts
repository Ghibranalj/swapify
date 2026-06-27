declare const _default: () => {
    port: number;
    database: {
        path: string;
    };
    jwt: {
        secret: string;
        expiresIn: number;
    };
    google: {
        clientId: string;
    };
    minio: {
        endpoint: string;
        port: number;
        accessKey: string;
        secretKey: string;
        bucket: string;
        useSSL: boolean;
    };
};
export default _default;
