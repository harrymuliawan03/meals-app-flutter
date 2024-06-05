import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/modules/meals/models/meals.dart';

Future<List<Meal>> getMealsService() async {
  final response = await http
      .get(Uri.parse('https://6658941e5c361705264910e7.mockapi.io/meals'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((meal) => Meal.fromJson(meal)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}

Future<bool> createMealService(String body) async {
  final headers = {'Content-Type': 'application/json'};
  final response = await http.post(
      Uri.parse('https://6658941e5c361705264910e7.mockapi.io/meals'),
      headers: headers,
      body: body);

  if (response.statusCode == 201) {
    return true;
  } else {
    // throw Exception('Failed to load meals');
    return false;
  }
}

Future<bool> updateMealService(String body, int id) async {
  final headers = {'Content-Type': 'application/json'};
  final response = await http.patch(
      Uri.parse('https://6658941e5c361705264910e7.mockapi.io/meals/$id'),
      headers: headers,
      body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    // throw Exception('Failed to load meals');
    return false;
  }
}

Future<bool> deleteMealService(int id) async {
  final headers = {'Content-Type': 'application/json'};
  final response = await http.delete(
    Uri.parse('https://6658941e5c361705264910e7.mockapi.io/meals/$id'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    // throw Exception('Failed to load meals');
    return false;
  }
}
