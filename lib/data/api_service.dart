import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://100.105.172.126:8000/api';
  static String? _token;

  // --- INISIALISASI TOKEN ---
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('=========================================');
    print('[API] Memeriksa sesi login sebelumnya...');
    print('[API] Token ditemukan: ${_token != null ? "Ya" : "Tidak"}');
    print('=========================================');
  }

  static bool get isLoggedIn => _token != null;

  // --- FUNGSI LOGIN ---
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['data'] != null && responseData['data']['token'] != null) {
          _token = responseData['data']['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
        }
        return {'success': true, 'message': 'Login berhasil', 'data': responseData};
      } else {
        return {'success': false, 'message': 'Akses ditolak. (Status Code: ${response.statusCode})'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // --- FUNGSI AMBIL DATA USER (PROFIL) ---
  static Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/user');
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 401) {
        await logout();
        return {'success': false, 'message': 'Sesi habis.', 'is_unauthorized': true};
      }
      return {'success': false, 'message': 'API Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': 'Connection Error: $e'};
    }
  }

  // --- FUNGSI AMBIL DATA DASHBOARD (MENDUKUNG MULTI PROJECT) ---
  static Future<Map<String, dynamic>> getDashboardData({List<int>? projectIds}) async {
    // Bangun URL dengan parameter array
    String urlString = '$baseUrl/dashboard';
    
    if (projectIds != null && projectIds.isNotEmpty) {
      // Mengubah List [1, 2] menjadi string "?project_id[]=1&project_id[]=2"
      final queryParams = projectIds.map((id) => 'project_id[]=$id').join('&');
      urlString += '?$queryParams';
    }
    
    final url = Uri.parse(urlString);
    print('[API] GET Request to: $url');

    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 401) {
        await logout();
        return {'success': false, 'message': 'Sesi habis.', 'is_unauthorized': true};
      }
      return {'success': false, 'message': 'API Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': 'Connection Error: $e'};
    }
  }

  // --- FUNGSI AMBIL DATA PARAMETER (DAFTAR PROJECT DLL) ---
  static Future<Map<String, dynamic>> getDashboardParameters() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dashboard/parameters'), headers: _getHeaders());
      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else if (response.statusCode == 401) {
        await logout();
        return {'success': false, 'message': 'Sesi habis.', 'is_unauthorized': true};
      }
      return {'success': false, 'message': 'API Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': 'Connection Error: $e'};
    }
  }

  // --- FUNGSI LOGOUT ---
  static Future<void> logout() async {
    // Optional: Panggil API logout di server jika diperlukan
    // await http.post(Uri.parse('$baseUrl/logout'), headers: _getHeaders());
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // --- HELPER UNTUK HEADER ---
  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }
}