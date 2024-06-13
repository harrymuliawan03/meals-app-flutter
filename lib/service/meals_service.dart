import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/local_storage_service.dart';

final token = LocalStorage.getStringData('token');
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token'
};

Future<List<Meal>> getMealsService() async {
  try {
    final response = await http.get(
      Uri.parse('http://0.0.0.0:8000/api/meals'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<bool> createMealService(String body) async {
  try {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/meals'),
        headers: headers,
        body: body);

    if (response.statusCode == 201) {
      return true;
    } else {
      // throw Exception('Failed to load meals');
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> updateMealService(String body, int id) async {
  try {
    final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/meals/$id'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      // throw Exception('Failed to load meals');
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> deleteMealService(int id) async {
  try {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/meals/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // throw Exception('Failed to load meals');
      return false;
    }
  } catch (e) {
    return false;
  }
}
