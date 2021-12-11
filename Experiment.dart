class Experiment {
  final String id;
  final String title;
  final String description;
  final String status;
  final String progress;
  Experiment(
    this.id,
    this.title,
    this.description,
    this.status,
    this.progress,
  );

  String get getId {
    return this.id;
  }

  String get getTitle {
    return this.title;
  }

  String get getDescription {
    return this.description;
  }

  String get getStatus {
    return this.status;
  }

  String get getProgress {
    return this.progress;
  }

  factory Experiment.fromJson(Map<String, dynamic> json) {
    return Experiment(
      json['id'].toString(),
      json['title'],
      json['description'] != null ? json['description'].toString() : '',
      json['status'].toString(),
      json['progress'] != null ? json['progress'].toString() : '0',
    );
  }
}
