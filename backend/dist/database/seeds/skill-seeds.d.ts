import { DataSource } from 'typeorm';
export declare const SEED_SKILLS: {
    name: string;
    category: string;
}[];
export declare function seedSkills(dataSource: DataSource): Promise<void>;
