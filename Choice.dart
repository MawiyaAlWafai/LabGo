class Choice {
  final id;
  final quizId;
  final description;
  final isCorrect;

  Choice(this.id, this.quizId, this.description, this.isCorrect);

  String get getId {
    return this.id;
  }

  String get getQuizId {
    return this.quizId;
  }

  String get getDescription {
    return this.description;
  }

  String get getIsCorrect {
    return this.isCorrect;
  }

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      json['id'].toString(),
      json['quiz_id'].toString(),
      json['description'] != null ? json['description'].toString() : '',
      json['is_correct'].toString(),
    );
  }
}
