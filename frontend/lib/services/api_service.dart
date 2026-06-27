import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  Map<String, dynamic>? _currentUser;

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;

  // Initialize and load saved token
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userJson = prefs.getString('current_user');
    if (userJson != null) {
      _currentUser = json.decode(userJson);
    }
  }

  // Save auth data
  Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    _token = token;
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('current_user', json.encode(user));
  }

  // Clear auth data
  Future<void> logout() async {
    if (_token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.url}/auth/logout'),
          headers: _headers,
        );
      } catch (_) {}
    }
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('current_user');
  }

  // Headers helper
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // Dev test login (POST /auth/google with dev-test-token)
  Future<Map<String, dynamic>> loginDev([String? name]) async {
    final tokenValue = name != null && name.trim().isNotEmpty
        ? 'dev-test-token:${Uri.encodeComponent(name.trim())}'
        : 'dev-test-token:new-user-${DateTime.now().millisecondsSinceEpoch}';

    final response = await http.post(
      Uri.parse('${ApiConfig.url}/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': tokenValue}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      final token = data['accessToken'];
      final user = data['user'];
      await _saveAuthData(token, user);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Get self profile (GET /users/me)
  Future<Map<String, dynamic>> getMyProfile() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.url}/users/me'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final profile = json.decode(response.body);
      _currentUser = profile;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(profile));
      return profile;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  // Update profile name & bio (PUT /users/me)
  Future<Map<String, dynamic>> updateProfile({String? name, String? bio}) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (bio != null) body['bio'] = bio;

    final response = await http.put(
      Uri.parse('${ApiConfig.url}/users/me'),
      headers: _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final profile = json.decode(response.body);
      _currentUser = profile;
      return profile;
    } else {
      throw Exception('Failed to update profile');
    }
  }

  // Upload Profile Image (POST /users/me/profile-image)
  Future<String> uploadProfileImage(File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.url}/users/me/profile-image'),
    );
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['profileImageUrl'] ?? '';
    } else {
      throw Exception('Failed to upload image: ${response.body}');
    }
  }

  // Get all skills in DB (GET /skills)
  Future<List<dynamic>> getAllSkills() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.url}/skills?limit=100'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['skills'] ?? [];
    } else {
      throw Exception('Failed to load skills list');
    }
  }

  // Add User Skill offered (POST /users/me/skills)
  Future<void> addUserSkill(String skillId, {int proficiency = 3}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.url}/users/me/skills'),
      headers: _headers,
      body: json.encode({
        'skillId': skillId,
        'proficiency': proficiency,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add user skill: ${response.body}');
    }
  }

  // Remove User Skill offered (DELETE /users/me/skills/:id)
  Future<void> removeUserSkill(String skillId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.url}/users/me/skills/$skillId'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove skill');
    }
  }

  // Add Learning Goal (POST /users/me/learning-goals)
  Future<void> addLearningGoal(String skillId, {int priority = 3}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.url}/users/me/learning-goals'),
      headers: _headers,
      body: json.encode({
        'skillId': skillId,
        'priority': priority,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add learning goal: ${response.body}');
    }
  }

  // Remove Learning Goal (DELETE /users/me/learning-goals/:id)
  Future<void> removeLearningGoal(String goalId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.url}/users/me/learning-goals/$goalId'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove learning goal');
    }
  }

  // Upload Certificate (POST /certificates/upload)
  Future<Map<String, dynamic>> uploadCertificate(File file, String title, String skillId) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.url}/certificates/upload'),
    );
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['title'] = title;
    request.fields['skillId'] = skillId;

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload certificate: ${response.body}');
    }
  }

  // Fetch match Feed (GET /feed)
  Future<List<dynamic>> getFeed({String? category, String? search}) async {
    String url = '${ApiConfig.url}/feed?limit=50';
    if (category != null && category != 'All') {
      url += '&category=${Uri.encodeComponent(category)}';
    }
    if (search != null && search.isNotEmpty) {
      url += '&search=${Uri.encodeComponent(search)}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['users'] ?? [];
    } else {
      throw Exception('Failed to load feed: ${response.body}');
    }
  }

  // Create swap request (POST /swap-requests)
  Future<Map<String, dynamic>> createSwapRequest({
    required String providerId,
    required String requesterSkillId,
    required String providerSkillId,
    String? message,
  }) async {
    final body = {
      'providerId': providerId,
      'requesterSkillId': requesterSkillId,
      'providerSkillId': providerSkillId,
      if (message != null && message.isNotEmpty) 'message': message,
    };

    final response = await http.post(
      Uri.parse('${ApiConfig.url}/swap-requests'),
      headers: _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create swap request: ${response.body}');
    }
  }

  // Get my swap requests (GET /swap-requests)
  Future<List<dynamic>> getSwapRequests({String? status}) async {
    String url = '${ApiConfig.url}/swap-requests?limit=100';
    if (status != null) {
      url += '&status=$status';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['requests'] ?? result['data'] ?? [];
    } else {
      throw Exception('Failed to load swap requests');
    }
  }

  // Accept swap request (PUT /swap-requests/:id/accept)
  Future<void> acceptSwapRequest(String id) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.url}/swap-requests/$id/accept'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept swap request');
    }
  }

  // Decline swap request (PUT /swap-requests/:id/decline)
  Future<void> declineSwapRequest(String id) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.url}/swap-requests/$id/decline'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to decline swap request');
    }
  }

  // Cancel swap request (PUT /swap-requests/:id/cancel)
  Future<void> cancelSwapRequest(String id) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.url}/swap-requests/$id/cancel'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to cancel swap request');
    }
  }

  // Complete swap request (PUT /swap-requests/:id/complete)
  Future<void> completeSwapRequest(String id) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.url}/swap-requests/$id/complete'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to complete swap request');
    }
  }

  // Rate completed swap (POST /swap-requests/:id/rate)
  Future<void> rateSwapRequest(String id, {required int rating, String? comment}) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.url}/swap-requests/$id/rate'),
      headers: _headers,
      body: json.encode({
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to rate swap request');
    }
  }

  // Get message threads (GET /messages/threads)
  Future<List<dynamic>> getThreads() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.url}/messages/threads'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['threads'] ?? [];
    } else {
      throw Exception('Failed to load chat threads');
    }
  }

  // Get thread messages (GET /messages/:swapRequestId)
  Future<List<dynamic>> getMessages(String swapRequestId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.url}/messages/$swapRequestId?limit=100'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rawList = data['messages'] ?? [];
      return rawList.map((m) {
        return {
          'id': m['id'],
          'content': m['text'] ?? m['content'],
          'senderId': m['isSender'] == true ? (ApiService().currentUser?['id'] ?? '') : 'other',
          'createdAt': m['createdAt'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // Send message (POST /messages/:swapRequestId)
  Future<Map<String, dynamic>> sendMessage(String swapRequestId, String content) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.url}/messages/$swapRequestId'),
      headers: _headers,
      body: json.encode({'content': content}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  // Get notifications (GET /notifications)
  Future<List<dynamic>> getNotifications() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.url}/notifications?limit=100'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['data'] ?? [];
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Upgrade to premium subscription (POST /subscriptions)
  Future<void> upgradeToPremium(String planId, String paymentMethod, Map<String, dynamic> paymentDetails) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.url}/subscriptions'),
      headers: _headers,
      body: json.encode({
        'planId': planId,
        'paymentMethod': paymentMethod,
        'paymentDetails': paymentDetails,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Refresh my profile locally to reflect premium status
      await getMyProfile();
    } else {
      throw Exception('Failed to subscribe: ${response.body}');
    }
  }

  // Delete certificate (DELETE /certificates/:id)
  Future<void> deleteCertificate(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.url}/certificates/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete certificate');
    }
  }
}
