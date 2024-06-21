import 'package:dio/dio.dart';
import 'package:meals_app/modules/categories/models/category_model.dart';
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

Future<List<CategoryModel>> getCategoriesService() async {
  try {
    final response = await dio.get(
      '/categories',
      onReceiveProgress: (count, total) {
        print('count: $count, total: $total');
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((category) => CategoryModel.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
