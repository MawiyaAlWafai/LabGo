class Quiz {
  final quizId;
  final quizExperimentId;
  final quizDesc;
  final choices;

  Quiz(this.quizId, this.quizExperimentId, this.quizDesc, this.choices);

  String get getQuizId {
    return this.quizId;
  }

  String get getQuizExperimentId {
    return this.quizExperimentId;
  }

  String get getQuizDesc {
    return this.quizDesc;
  }

  List<dynamic> get getChoices {
    return this.choices;
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      json['quizId'].toString(),
      json['quizExperimentId'].toString(),
      json['quizDesc'] != null ? json['quizDesc'].toString() : '',
      json['choices'] != null ? json['choices'] as List<dynamic> : [],
    );
  }
}
