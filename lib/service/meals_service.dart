import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:meals_app/modules/meals/models/meals.dart';
import 'package:meals_app/service/local_storage_service.dart';

final token = LocalStorage.getStringData('token');
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token'
};
final dio = Dio(BaseOptions(
  baseUrl: 'http://0.0.0.0:8000/api',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: headers,
));

Future<List<Meal>> getMealsService() async {
  try {
    final response = await dio.get(
      '/meals',
      onReceiveProgress: (count, total) {
        print('count: $count, total: $total');
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((meal) => Meal.fromJson(meal)).toList();
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<bool> createMealService(String body) async {
  try {
    final response = await dio.post(
      '/meals',
      data: body,
      onSendProgress: (count, total) {
        print('count: $count, total: $total');
      },
    );

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
    final response = await dio.put(
      '/meals/$id',
      data: body,
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

Future<bool> deleteMealService(int id) async {
  try {
    final response = await dio.delete(
      '/meals/$id',
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
