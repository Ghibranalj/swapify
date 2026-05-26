class UserModel {
  final String id;
  final String name;
  final String rating;
  final String swaps;
  final String imageAsset;
  final String bio;
  final List<String> categories;
  final List<String> skills;
  final List<String> learningGoals;
  final List<String> certificates;

  UserModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.swaps,
    required this.imageAsset,
    required this.bio,
    required this.categories,
    required this.skills,
    required this.learningGoals,
    required this.certificates,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: json['rating'] ?? '0.0',
      swaps: json['swaps'] ?? '0',
      imageAsset: json['imageAsset'] ?? '',
      bio: json['bio'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      learningGoals: List<String>.from(json['learningGoals'] ?? []),
      certificates: List<String>.from(json['certificates'] ?? []),
    );
  }
}

// Dummy Data 
final List<UserModel> dummyUsers = [
  UserModel(
    id: '1',
    name: 'Maya Rodriguez',
    rating: '4.8',
    swaps: '18',
    imageAsset: 'images/user1.png',
    bio: 'Guitarist & language enthusiast. Let’s trade chords for conversational skills!',
    categories: ['Language', 'Music'],
    skills: ['Spanish', 'Guitar', 'Singing'],
    learningGoals: ['UI/UX Design', 'Photography', 'Video Editing'],
    certificates: ['images/certificate1.png', 'images/certificate2.png'],
  ),
  UserModel(
    id: '2',
    name: 'Jordan Kim',
    rating: '4.7',
    swaps: '14',
    imageAsset: 'images/user2.png',
    bio: 'Full-stack software engineer loving clean architectures. Want to learn digital arts.',
    categories: ['Coding'],
    skills: ['Web Development', 'Python', 'Flutter'],
    learningGoals: ['Digital Painting', 'UI/UX Design'],
    certificates: ['images/certificate3.png'],
  ),
  UserModel(
    id: '3',
    name: 'Alex Chen',
    rating: '4.9',
    swaps: '22',
    imageAsset: 'images/user1.png', 
    bio: 'Senior Product Designer at a tech startup. Wanting to pick up Python or basic coding.',
    categories: ['Design', 'Art'],
    skills: ['UI/UX Design', 'Figma', 'Illustration'],
    learningGoals: ['Python', 'Web Development'],
    certificates: ['images/certificate1.png', 'images/certificate3.png'],
  ),
];