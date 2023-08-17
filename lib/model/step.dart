class Step {
  static String getIrifromId(int id) {
    return '/api/steps/$id';
  }

  int id;
  String title;
  String instruction;
  String recipeURI;
  int position;

  get iri => Step.getIrifromId(id);

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
