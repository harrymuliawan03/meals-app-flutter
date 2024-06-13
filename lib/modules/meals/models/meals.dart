enum Complexity {
  simple,
  challenging,
  hard,
}

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

class Meal {
  final int id;
  final List<String> categories;
  final String title;
  final String? imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;
  final bool isVegetarian;

  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.isVegetarian,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as int,
      categories: List<String>.from(json['categories']),
      title: json['title'] as String,
      imageUrl: json['image'] as String?,
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
      duration: json['duration'] as int,
      complexity: _complexityFromString(json['complexity']),
      affordability: _affordabilityFromString(json['affordability']),
      isGlutenFree: json['isGlutenFree'] as bool,
      isLactoseFree: json['isLactoseFree'] as bool,
      isVegan: json['isVegan'] as bool,
      isVegetarian: json['isVegetarian'] as bool,
    );
  }

  static Complexity _complexityFromString(String complexity) {
    switch (complexity) {
      case 'simple':
        return Complexity.simple;
      case 'challenging':
        return Complexity.challenging;
      case 'hard':
        return Complexity.hard;
      default:
        throw Exception('Unknown complexity: $complexity');
    }
  }

  static Affordability _affordabilityFromString(String affordability) {
    switch (affordability) {
      case 'affordable':
        return Affordability.affordable;
      case 'pricey':
        return Affordability.pricey;
      case 'luxurious':
        return Affordability.luxurious;
      default:
        throw Exception('Unknown affordability: $affordability');
    }
  }
}
