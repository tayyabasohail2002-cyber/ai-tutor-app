import 'package:dio/dio.dart';

const baseUrl = "http://127.0.0.1:8000";
//const baseUrl = "http://192.168.1.10:8000";

class ApiService {
  final Dio _dio = Dio();

  // ================= REGISTER =================
  Future<Map<String, dynamic>?> register(String email, String password) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/register",
        data: {"email": email, "password": password},
      );
      return response.data;
    } on DioException catch (e) {
      print("Register Error: ${e.response?.data}");
      return null;
    }
  }

  // ================= LOGIN =================
 Future<Map<String, dynamic>?> login(String email, String password) async {
  try {
    final response = await _dio.post(
      "$baseUrl/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    return response.data;
  } on DioException catch (e) {
    print("Login Error: ${e.response?.data}");
    return null;
  }
}

  // ================= GENERATE SCRIPT =================
  Future<Map<String, dynamic>?> generateScript({
    required int userId,
    required String prompt,
    required String gender,
  }) async {
    print(
        "Calling generateScript with userId=$userId, prompt='$prompt', gender=$gender");
    try {
      final response = await _dio.post(
        "$baseUrl/tutor/generate/script?user_id=$userId",
        data: {"prompt": prompt.trim(), "gender": gender},
      );
      print("Script Status Code: ${response.statusCode}");
      print("Script Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("Generate Script Error: ${e.response?.data}");
      return {"error": "Failed to generate script."};
    }
  }

  // ================= GENERATE AUDIO =================
  Future<Map<String, dynamic>?> generateAudio(int videoId) async {
    try {
      final response = await _dio.post(
        "$baseUrl/tutor/generate/audio",
        queryParameters: {"video_id": videoId},
      );
      return response.data;
    } on DioException catch (e) {
      print("Generate Audio Error: ${e.response?.data}");
      return null;
    }
  }

  // ================= UPLOAD IMAGE =================
  Future<Map<String, dynamic>?> uploadImageWeb(
      int videoId, List<int> bytes, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes, filename: fileName),
      });
      final response = await _dio.post(
        "$baseUrl/tutor/upload-image",
        queryParameters: {"video_id": videoId},
        data: formData,
      );
      return response.data;
    } catch (e) {
      print("Upload Image Error: $e");
      return null;
    }
  }

  // ================= GENERATE VIDEO =================
  Future<Map<String, dynamic>?> generateVideo(int videoId) async {
    try {
      final response = await _dio.post(
        "$baseUrl/tutor/generate/video",
        queryParameters: {"video_id": videoId},
      );
      return response.data;
    } catch (e) {
      print("Generate Video Error: $e");
      return null;
    }
  }
}
