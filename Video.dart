class Video {
  final id;
  final experimentId;
  final url;
  final description;

  Video(this.id, this.experimentId, this.url, this.description);

  String get getId {
    return this.id;
  }

  String get getExperimentId {
    return this.experimentId;
  }

  String get getUrl {
    return this.url;
  }

  String get getDescription {
    return this.description;
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      json['id'].toString(),
      json['experiment_id'].toString(),
      json['url'] != null ? json['url'].toString() : '',
      json['description'] != null ? json['description'].toString() : '',
    );
  }
}
