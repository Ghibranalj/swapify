import { DataSource, DeepPartial } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Skill } from '../../skills/entities/skill.entity';
import { UserSkill } from '../../skills/entities/user-skill.entity';
import { UserLearningGoal } from '../../skills/entities/user-learning-goal.entity';
import { SwapRequest } from '../../swap-requests/entities/swap-request.entity';

export async function seedUsers(dataSource: DataSource): Promise<void> {
  const userRepo = dataSource.getRepository(User);
  const skillRepo = dataSource.getRepository(Skill);
  const userSkillRepo = dataSource.getRepository(UserSkill);
  const goalRepo = dataSource.getRepository(UserLearningGoal);
  const swapRepo = dataSource.getRepository(SwapRequest);

  // Check if we already seeded users
  const existingSeed = await userRepo.findOne({ where: { googleId: 'dev-google-id-static' } });
  if (existingSeed) {
    console.log('Mock users already seeded. Skipping.');
    return;
  }

  console.log('Seeding mock users, skills, and swap requests...');

  // Clean old data to start fresh and avoid duplicates
  try {
    await swapRepo.delete({});
    await goalRepo.delete({});
    await userSkillRepo.delete({});
    await userRepo.delete({});
  } catch (err) {
    console.warn('Error clearing old data (might be empty or missing tables):', err);
  }

  // 1. Get skills mapped by name
  const skillsList = await skillRepo.find();
  const skillsMap: Record<string, Skill> = {};
  skillsList.forEach(s => {
    skillsMap[s.name] = s;
  });

  // Helper to find skill
  const getSkill = (name: string) => {
    return skillsMap[name] || skillsList[0];
  };

  // 2. Create users
  const usersData: DeepPartial<User>[] = [
    {
      googleId: 'dev-google-id-static',
      email: 'dev-user@test.com',
      name: 'Dev User',
      bio: 'Enthusiastic learner testing the Swapify app.',
      profileImageUrl: undefined,
      isPremium: false,
      swapCount: 4,
    },
    {
      googleId: 'dev-andi',
      email: 'andi.pratama@test.com',
      name: 'Andi Pratama',
      bio: 'Computer Science student. Highly passionate about coding in Python and React.',
      profileImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
      isPremium: true,
      swapCount: 8,
    },
    {
      googleId: 'dev-rian',
      email: 'rian.wijaya@test.com',
      name: 'Rian Wijaya',
      bio: 'UI/UX Designer. Figma is my playground. Passionate about beautiful interfaces.',
      profileImageUrl: 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&w=150&q=80',
      isPremium: true,
      swapCount: 10,
    },
    {
      googleId: 'dev-siti',
      email: 'siti.rahma@test.com',
      name: 'Siti Rahma',
      bio: 'Language major. Multilingual and love sharing English and Japanese speaking tips.',
      profileImageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
      isPremium: false,
      swapCount: 12,
    },
    {
      googleId: 'dev-budi',
      email: 'budi.santoso@test.com',
      name: 'Budi Santoso',
      bio: 'Music student. Can teach guitar and piano basics.',
      profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
      isPremium: false,
      swapCount: 6,
    },
    {
      googleId: 'dev-clara',
      email: 'clara.angelica@test.com',
      name: 'Clara Angelica',
      bio: 'Digital artist. Specializing in 2D animation and painting.',
      profileImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
      isPremium: true,
      swapCount: 15,
    },
  ];

  const createdUsers: Record<string, User> = {};
  for (const ud of usersData) {
    const user = userRepo.create(ud);
    const saved = await userRepo.save(user);
    createdUsers[saved.name] = saved;
  }

  // 3. Add Skills and Learning Goals to users
  const userSetup = [
    {
      name: 'Dev User',
      skills: [{ name: 'Flutter', prof: 4 }, { name: 'Golang', prof: 3 }],
      goals: [{ name: 'UI/UX Design', prio: 4 }, { name: 'Figma', prio: 5 }]
    },
    {
      name: 'Andi Pratama',
      skills: [{ name: 'Python', prof: 4 }, { name: 'React', prof: 4 }],
      goals: [{ name: 'Golang', prio: 4 }, { name: 'Web Development', prio: 3 }]
    },
    {
      name: 'Rian Wijaya',
      skills: [{ name: 'UI/UX Design', prof: 5 }, { name: 'Figma', prof: 5 }],
      goals: [{ name: 'Flutter', prio: 4 }, { name: 'Web Development', prio: 3 }]
    },
    {
      name: 'Siti Rahma',
      skills: [{ name: 'English', prof: 5 }, { name: 'Japanese', prof: 4 }],
      goals: [{ name: 'Python', prio: 5 }, { name: 'Flutter', prio: 3 }]
    },
    {
      name: 'Budi Santoso',
      skills: [{ name: 'Guitar', prof: 4 }, { name: 'Piano', prof: 4 }],
      goals: [{ name: 'Golang', prio: 4 }, { name: 'Japanese', prio: 3 }]
    },
    {
      name: 'Clara Angelica',
      skills: [{ name: 'Digital Painting', prof: 5 }, { name: 'Animation', prof: 4 }],
      goals: [{ name: 'UI/UX Design', prio: 4 }, { name: 'Figma', prio: 3 }]
    }
  ];

  for (const setup of userSetup) {
    const user = createdUsers[setup.name];
    for (const sk of setup.skills) {
      const skillEntity = getSkill(sk.name);
      await userSkillRepo.save(userSkillRepo.create({
        userId: user.id,
        skillId: skillEntity.id,
        proficiency: sk.prof
      }));
    }
    for (const gl of setup.goals) {
      const skillEntity = getSkill(gl.name);
      await goalRepo.save(goalRepo.create({
        userId: user.id,
        skillId: skillEntity.id,
        priority: gl.prio
      }));
    }
  }

  // 4. Create completed mock SwapRequests to populate ratings
  const devUser = createdUsers['Dev User'];
  const andi = createdUsers['Andi Pratama'];
  const rian = createdUsers['Rian Wijaya'];
  const siti = createdUsers['Siti Rahma'];
  const budi = createdUsers['Budi Santoso'];
  const clara = createdUsers['Clara Angelica'];

  const swaps = [
    // Rian and Dev User swap
    {
      requesterId: devUser.id,
      providerId: rian.id,
      requesterSkillId: getSkill('Flutter').id,
      providerSkillId: getSkill('UI/UX Design').id,
      status: 'done',
      rating: 5,
      ratingComment: 'Dev User did an amazing job explaining Flutter architectures!',
      message: 'Let’s swap UI/UX for Flutter coding!',
    },
    // Clara and Dev User swap
    {
      requesterId: clara.id,
      providerId: devUser.id,
      requesterSkillId: getSkill('Digital Painting').id,
      providerSkillId: getSkill('Flutter').id,
      status: 'done',
      rating: 5,
      ratingComment: 'Explained widget lifecycles thoroughly.',
      message: 'Hi, I can teach you digital painting if you teach me Flutter!',
    },
    // Andi and Clara swap
    {
      requesterId: andi.id,
      providerId: clara.id,
      requesterSkillId: getSkill('Python').id,
      providerSkillId: getSkill('Animation').id,
      status: 'done',
      rating: 5,
      ratingComment: 'Andi is very clear in teaching basic python algorithms!',
      message: 'Hey Clara, let’s trade Python for Animation.',
    },
    // Rian and Andi swap
    {
      requesterId: rian.id,
      providerId: andi.id,
      requesterSkillId: getSkill('Figma').id,
      providerSkillId: getSkill('React').id,
      status: 'done',
      rating: 4,
      ratingComment: 'Great React components created together.',
      message: 'Want to trade Figma design for React tips?',
    },
    // Siti and Rian swap
    {
      requesterId: rian.id,
      providerId: siti.id,
      requesterSkillId: getSkill('Figma').id,
      providerSkillId: getSkill('Japanese').id,
      status: 'done',
      rating: 4,
      ratingComment: 'Very polite and great conversational Japanese partner.',
      message: 'Hey Siti, want to learn Figma?',
    },
    // Budi and Siti swap
    {
      requesterId: siti.id,
      providerId: budi.id,
      requesterSkillId: getSkill('English').id,
      providerSkillId: getSkill('Guitar').id,
      status: 'done',
      rating: 5,
      ratingComment: 'Budi is very patient in teaching guitar chords.',
      message: 'Let’s trade English for Guitar!',
    }
  ];

  for (const sw of swaps) {
    await swapRepo.save(swapRepo.create(sw as any));
  }

  console.log('Seeded users, skills, and ratings successfully!');
}
