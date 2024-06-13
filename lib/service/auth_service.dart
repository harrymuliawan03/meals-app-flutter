import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/modules/auth/model/auth_model.dart';
import 'package:meals_app/modules/auth/model/login_response_model.dart';
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/local_storage_service.dart';

class AuthService {
  final headers = {'Content-Type': 'application/json'};
  Future<ResponseLogin> loginService(String email, String password) async {
    try {
      final body = jsonEncode({"email": email, "password": password});
      final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/login'),
          body: body,
          headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final user = UserModel.fromJson(data['data']);
        await LocalStorage.saveData<String>('token', data['access_token']);
        return ResponseLogin(
          valid: true,
          role: user.role == 'admin' ? 'admin' : 'user',
          name: user.name,
        );
      } else {
        return ResponseLogin(valid: false, role: null, name: null);
      }
    } catch (e) {
      return ResponseLogin(valid: false, role: null, name: null);
    }
  }

  Future<bool> registerService(
      String name, String email, String password) async {
    try {
      final body = jsonEncode({
        "name": name,
        "email": email,
        "role": "user",
        "password": password,
      });

      final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/register'),
          headers: headers,
          body: body);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
