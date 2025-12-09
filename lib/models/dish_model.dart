class PopularDish {
  final int id;
  final String name;
  final String image;

  PopularDish({required this.id, required this.name, required this.image});

  factory PopularDish.fromJson(Map<String, dynamic> json) {
    return PopularDish(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Dish {
  final int id;
  final String name;
  final double rating;
  final String description;
  final List<String> equipments;
  final String image;

  Dish({
    required this.id,
    required this.name,
    required this.rating,
    required this.description,
    required this.equipments,
    required this.image,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      equipments: List<String>.from(json['equipments'] ?? []),
      image: json['image'] ?? '',
    );
  }
}

class IngredientItem {
  final String name;
  final String quantity;

  IngredientItem({required this.name, required this.quantity});

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(name: json['name'], quantity: json['quantity']);
  }
}

class ApplianceItem {
  final String name;
  final String image;

  ApplianceItem({required this.name, required this.image});

  factory ApplianceItem.fromJson(Map<String, dynamic> json) {
    return ApplianceItem(name: json['name'], image: json['image']);
  }
}

class DishDetail {
  final int id;
  final String name;
  final String timeToPrepare;
  final double rating;
  final String image;
  final List<IngredientItem> vegetables;
  final List<IngredientItem> spices;
  final List<ApplianceItem> appliances;

  DishDetail({
    required this.id,
    required this.name,
    required this.timeToPrepare,
    required this.rating,
    required this.image,
    required this.vegetables,
    required this.spices,
    required this.appliances,
  });

  factory DishDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = json['ingredients'] as Map<String, dynamic>?;
    return DishDetail(
      id: json['id'],
      name: json['name'],
      timeToPrepare: json['timeToPrepare'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      vegetables: (ingredients?['vegetables'] as List?)
              ?.map((e) => IngredientItem.fromJson(e))
              .toList() ??
          [],
      spices: (ingredients?['spices'] as List?)
              ?.map((e) => IngredientItem.fromJson(e))
              .toList() ??
          [],
      appliances: (json['appliances'] as List?)
              ?.map((e) => ApplianceItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}
