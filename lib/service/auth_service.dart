import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/modules/auth/model/auth_model.dart';
import 'package:meals_app/modules/auth/model/login_response_model.dart';
import 'package:meals_app/modules/meals/models/meals.dart';

class AuthService {
  Future<ResponseLogin> loginService(String email, String password) async {
    try {
      final response = await http
          .get(Uri.parse('https://6658941e5c361705264910e7.mockapi.io/user'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final listUser = data.map((meal) => UserModel.fromJson(meal)).toList();
        for (var user in listUser) {
          if (user.email == email && user.password == password) {
            return ResponseLogin(
              valid: true,
              role: user.role == 'admin' ? 'admin' : 'user',
              name: user.name,
            );
          }
        }
        return ResponseLogin(valid: false, role: null, name: null);
      } else {
        return ResponseLogin(valid: false, role: null, name: null);
      }
    } catch (e) {
      return ResponseLogin(valid: false, role: null, name: null);
    }
  }

  Future<bool> registerService(String body) async {
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
        Uri.parse('https://6658941e5c361705264910e7.mockapi.io/user'),
        headers: headers,
        body: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      // throw Exception('Failed to load meals');
      return false;
    }
  }
}
