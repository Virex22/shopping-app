class Step {
  int id;
  String title;
  String instruction;
  String recipeURI;
  int position;

  Step({
    required this.id,
    required this.title,
    required this.instruction,
    required this.recipeURI,
    required this.position,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      id: json['id'],
      title: json['title'],
      instruction: json['instruction'],
      recipeURI: json['recipe'],
      position: json['position'],
    );
  }
}
