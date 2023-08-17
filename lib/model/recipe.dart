import 'package:shopping_app/model/step.dart';

class Recipe {
  static String getIrifromId(int id) {
    return '/api/recipes/$id';
  }

  int id;
  String title;
  int servings;
  DateTime time;
  List<Step> steps;
  DateTime dateAdd;

  get iri => Recipe.getIrifromId(id);

  Recipe({
    required this.id,
    required this.title,
    required this.servings,
    required this.time,
    required this.steps,
    required this.dateAdd,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Step> steps = [];
    if (json['steps'] != null) {
      steps = json['steps'].map((stepJson) => Step.fromJson(stepJson));
    }
    return Recipe(
      id: json['id'],
      title: json['title'],
      servings: json['servings'],
      time: DateTime.parse(json['time']),
      steps: steps,
      dateAdd: DateTime.parse(json['dateAdd']),
    );
  }
}
