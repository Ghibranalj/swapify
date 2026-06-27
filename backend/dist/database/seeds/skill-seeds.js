"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SEED_SKILLS = void 0;
exports.seedSkills = seedSkills;
const skill_entity_1 = require("../../skills/entities/skill.entity");
exports.SEED_SKILLS = [
    { name: 'Design Graphic', category: 'Design' },
    { name: 'UI/UX Design', category: 'Design' },
    { name: 'Figma', category: 'Design' },
    { name: 'Illustration', category: 'Design' },
    { name: 'Doodle', category: 'Design' },
    { name: 'Flutter', category: 'Coding' },
    { name: 'React Native', category: 'Coding' },
    { name: 'Python', category: 'Coding' },
    { name: 'JavaScript', category: 'Coding' },
    { name: 'Java', category: 'Coding' },
    { name: 'Golang', category: 'Coding' },
    { name: 'Database', category: 'Coding' },
    { name: 'React', category: 'Coding' },
    { name: 'Web Development', category: 'Coding' },
    { name: 'Spanish', category: 'Language' },
    { name: 'English', category: 'Language' },
    { name: 'Mandarin', category: 'Language' },
    { name: 'Japanese', category: 'Language' },
    { name: 'Korean', category: 'Language' },
    { name: 'Guitar', category: 'Music' },
    { name: 'Piano', category: 'Music' },
    { name: 'Singing', category: 'Music' },
    { name: 'Music Production', category: 'Music' },
    { name: 'Photography', category: 'Art' },
    { name: 'Animation', category: 'Art' },
    { name: '3D Modeling', category: 'Art' },
    { name: 'Video Editing', category: 'Art' },
    { name: 'Digital Painting', category: 'Art' },
];
async function seedSkills(dataSource) {
    const skillRepo = dataSource.getRepository(skill_entity_1.Skill);
    const existingCount = await skillRepo.count();
    if (existingCount === 0) {
        console.log('Seeding skills...');
        for (const skillData of exports.SEED_SKILLS) {
            const skill = skillRepo.create(skillData);
            await skillRepo.save(skill);
        }
        console.log(`Seeded ${exports.SEED_SKILLS.length} skills.`);
    }
    else {
        console.log(`Skills already seeded (${existingCount} found). Skipping.`);
    }
}
//# sourceMappingURL=skill-seeds.js.map