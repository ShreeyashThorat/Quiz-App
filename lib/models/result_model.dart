class ResultModel {
  int? level;
  int? totalQuestions;
  int? score;
  List<Quiz>? quiz;
  String? date;

  ResultModel(
      {this.level, this.totalQuestions, this.score, this.quiz, this.date});

  ResultModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    totalQuestions = json['totalQuestions'];
    score = json['score'];
    if (json['quiz'] != null) {
      quiz = <Quiz>[];
      json['quiz'].forEach((v) {
        quiz!.add(Quiz.fromJson(v));
      });
    }
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['totalQuestions'] = totalQuestions;
    data['score'] = score;
    if (quiz != null) {
      data['quiz'] = quiz!.map((v) => v.toJson()).toList();
    }
    data['date'] = date;
    return data;
  }
}

class Quiz {
  String? question;
  List<String>? options;
  String? givenAnswer;
  String? correctAnswer;
  String? explanation;
  String? category;

  Quiz(
      {this.question,
      this.options,
      this.givenAnswer,
      this.correctAnswer,
      this.explanation,
      this.category});

  Quiz.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    options = json['options'].cast<String>();
    givenAnswer = json['givenAnswer'];
    correctAnswer = json['correct_answer'];
    explanation = json['explanation'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['options'] = options;
    data['givenAnswer'] = givenAnswer;
    data['correct_answer'] = correctAnswer;
    data['explanation'] = explanation;
    data['category'] = category;
    return data;
  }
}
