import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dish_model.dart';

class ApiService {
  static const String baseUrl =
      'https://8b648f3c-b624-4ceb-9e7b-8028b7df0ad0.mock.pstmn.io/dishes/v1';

  Future<Map<String, dynamic>> fetchDishesData() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final popularDishes = (data['popularDishes'] as List)
          .map((e) => PopularDish.fromJson(e))
          .toList();
      final dishes = (data['dishes'] as List)
          .map((e) => Dish.fromJson(e))
          .toList();

      return {'popularDishes': popularDishes, 'dishes': dishes};
    } else {
      throw Exception('Failed to load dishes');
    }
  }

  Future<DishDetail> fetchDishDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return DishDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dish detail');
    }
  }
}
