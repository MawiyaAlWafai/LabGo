class Activation {
  final String activationCode;

  Activation(this.activationCode);

  String get getActivationCode {
    return this.activationCode;
  }

  factory Activation.fromJson(Map<String, dynamic> json) {
    final map = json["data"];
    return Activation(
      map.toString().isNotEmpty ? map['activation_code'].toString() : '',
    );
  }
}
