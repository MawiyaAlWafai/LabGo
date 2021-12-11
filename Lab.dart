class Lab {
  final id;
  final experimentId;
  final image;
  final toolImage;
  final toolOrder;
  final toolStep;
  final isTool;
  final toolTitle;

  Lab(this.id, this.experimentId, this.image, this.toolImage, this.toolOrder,
      this.toolStep, this.isTool, this.toolTitle);

  String get getId {
    return this.id;
  }

  String get getExperimentId {
    return this.experimentId;
  }

  String get getImage {
    return this.image;
  }

  String get getToolImage {
    return this.toolImage;
  }

  String get getToolOrder {
    return this.toolOrder;
  }

  String get getToolStep {
    return this.toolStep;
  }

  String get getIsToolOrStep {
    return this.isTool;
  }

  String get getToolTitle {
    return this.toolTitle;
  }

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      json['id'].toString(),
      json['experiment_id'].toString(),
      json['image'] != null ? json['image'].toString() : '',
      json['tool_image'] != null ? json['tool_image'].toString() : '',
      json['tool_order'].toString(),
      json['tool_step'].toString(),
      json['is_tool'].toString(),
      json['tool_title'].toString(),
    );
  }
}
