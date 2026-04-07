import 'api_service.dart';

class TutorService {
  final ApiService _api = ApiService();

  // ================= GENERATE SCRIPT =================
  Future<Map<String, dynamic>?> generateScript({
    required int userId,
    required String prompt,
    required String gender,
  }) async {
    return await _api.generateScript(
      userId: userId,
      prompt: prompt,
      gender: gender,
    );
  }

  // ================= GENERATE AUDIO =================
  Future<Map<String, dynamic>?> generateAudio(int videoId) async {
    return await _api.generateAudio(videoId);
  }

  // ================= UPLOAD IMAGE =================
  Future<Map<String, dynamic>?> uploadImageWeb(int videoId, List<int> bytes, String fileName) async {
    return await _api.uploadImageWeb(videoId, bytes, fileName);
  }

  // ================= GENERATE VIDEO =================
  Future<Map<String, dynamic>?> generateVideo(int videoId) async {
    return await _api.generateVideo(videoId);
  }
}