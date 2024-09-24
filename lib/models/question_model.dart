class QuestionModel {
  String? question;
  List<String>? options;
  String? id;
  String? level;
  String? correctAnswer;
  String? category;
  String? explanation;

  QuestionModel(
      {this.question,
      this.options,
      this.id,
      this.level,
      this.correctAnswer,
      this.category,
      this.explanation});

  QuestionModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'].cast<String>();
    id = json['id'];
    level = json['level'];
    correctAnswer = json['correctAnswer'];
    category = json['category'];
    explanation = json['explanation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['options'] = options;
    data['id'] = id;
    data['level'] = level;
    data['correctAnswer'] = correctAnswer;
    data['category'] = category;
    data['explanation'] = explanation;
    return data;
  }
}
