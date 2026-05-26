// lib/data/request_data.dart

class RequestItem {
  final String name;
  final String date;
  final String skill1;
  final String skill2;
  final String message;
  String tabType;

  RequestItem({
    required this.name,
    required this.date,
    required this.skill1,
    required this.skill2,
    required this.message,
    required this.tabType,
  });
}

// Global list that persists throughout the application session
List<RequestItem> dummyRequests = [
  RequestItem(
    name: "Maya Rodriguez",
    date: "03/03/2026",
    skill1: "Spanish",
    skill2: "UI/UX Design",
    message: "Hey! I'd love to learn UI/UX from you. I can teach you Spanish in exchange! 😊",
    tabType: "pending",
  ),
  RequestItem(
    name: "Alex Chen",
    date: "03/01/2026",
    skill1: "React",
    skill2: "Italian Cooking",
    message: "I'd love to learn cooking from you!",
    tabType: "active",
  ),
  RequestItem(
    name: "Sarah Jenkins",
    date: "25/02/2026",
    skill1: "UI/UX Design",
    skill2: "Photography",
    message: "Let's learn from each other! 📸",
    tabType: "done",
  ),
];