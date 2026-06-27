"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.seedUsers = seedUsers;
const user_entity_1 = require("../../users/entities/user.entity");
const skill_entity_1 = require("../../skills/entities/skill.entity");
const user_skill_entity_1 = require("../../skills/entities/user-skill.entity");
const user_learning_goal_entity_1 = require("../../skills/entities/user-learning-goal.entity");
const swap_request_entity_1 = require("../../swap-requests/entities/swap-request.entity");
async function seedUsers(dataSource) {
    const userRepo = dataSource.getRepository(user_entity_1.User);
    const skillRepo = dataSource.getRepository(skill_entity_1.Skill);
    const userSkillRepo = dataSource.getRepository(user_skill_entity_1.UserSkill);
    const goalRepo = dataSource.getRepository(user_learning_goal_entity_1.UserLearningGoal);
    const swapRepo = dataSource.getRepository(swap_request_entity_1.SwapRequest);
    const existingSeed = await userRepo.findOne({ where: { googleId: 'dev-google-id-static' } });
    if (existingSeed) {
        console.log('Mock users already seeded. Skipping.');
        return;
    }
    console.log('Seeding mock users, skills, and swap requests...');
    try {
        await swapRepo.delete({});
        await goalRepo.delete({});
        await userSkillRepo.delete({});
        await userRepo.delete({});
    }
    catch (err) {
        console.warn('Error clearing old data (might be empty or missing tables):', err);
    }
    const skillsList = await skillRepo.find();
    const skillsMap = {};
    skillsList.forEach(s => {
        skillsMap[s.name] = s;
    });
    const getSkill = (name) => {
        return skillsMap[name] || skillsList[0];
    };
    const usersData = [
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
    const createdUsers = {};
    for (const ud of usersData) {
        const user = userRepo.create(ud);
        const saved = await userRepo.save(user);
        createdUsers[saved.name] = saved;
    }
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
    const devUser = createdUsers['Dev User'];
    const andi = createdUsers['Andi Pratama'];
    const rian = createdUsers['Rian Wijaya'];
    const siti = createdUsers['Siti Rahma'];
    const budi = createdUsers['Budi Santoso'];
    const clara = createdUsers['Clara Angelica'];
    const swaps = [
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
        await swapRepo.save(swapRepo.create(sw));
    }
    console.log('Seeded users, skills, and ratings successfully!');
}
//# sourceMappingURL=user-seeds.js.map