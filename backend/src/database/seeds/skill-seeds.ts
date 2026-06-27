import { DataSource } from 'typeorm';
import { Skill } from '../../skills/entities/skill.entity';

export const SEED_SKILLS = [
  // Design
  { name: 'Design Graphic', category: 'Design' },
  { name: 'UI/UX Design', category: 'Design' },
  { name: 'Figma', category: 'Design' },
  { name: 'Illustration', category: 'Design' },
  { name: 'Doodle', category: 'Design' },
  // Coding
  { name: 'Flutter', category: 'Coding' },
  { name: 'React Native', category: 'Coding' },
  { name: 'Python', category: 'Coding' },
  { name: 'JavaScript', category: 'Coding' },
  { name: 'Java', category: 'Coding' },
  { name: 'Golang', category: 'Coding' },
  { name: 'Database', category: 'Coding' },
  { name: 'React', category: 'Coding' },
  { name: 'Web Development', category: 'Coding' },
  // Language
  { name: 'Spanish', category: 'Language' },
  { name: 'English', category: 'Language' },
  { name: 'Mandarin', category: 'Language' },
  { name: 'Japanese', category: 'Language' },
  { name: 'Korean', category: 'Language' },
  // Music
  { name: 'Guitar', category: 'Music' },
  { name: 'Piano', category: 'Music' },
  { name: 'Singing', category: 'Music' },
  { name: 'Music Production', category: 'Music' },
  // Art
  { name: 'Photography', category: 'Art' },
  { name: 'Animation', category: 'Art' },
  { name: '3D Modeling', category: 'Art' },
  { name: 'Video Editing', category: 'Art' },
  { name: 'Digital Painting', category: 'Art' },
];

export async function seedSkills(dataSource: DataSource): Promise<void> {
  const skillRepo = dataSource.getRepository(Skill);
  const existingCount = await skillRepo.count();

  if (existingCount === 0) {
    console.log('Seeding skills...');
    for (const skillData of SEED_SKILLS) {
      const skill = skillRepo.create(skillData);
      await skillRepo.save(skill);
    }
    console.log(`Seeded ${SEED_SKILLS.length} skills.`);
  } else {
    console.log(`Skills already seeded (${existingCount} found). Skipping.`);
  }
}
