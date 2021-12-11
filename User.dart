import 'dart:convert';

import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  final String id;
  final String username;
  final String email;
  final String role;
  final String image;

  User(this.id, this.username, this.email, this.role, this.image);

  String get getId {
    return this.id;
  }

  String get getUsername {
    return this.username;
  }

  String get getEmail {
    return this.email;
  }

  String get getRole {
    return this.role;
  }

  String get getImage {
    return this.image;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final map = json["data"];
    return User(
      map['id'].toString(),
      map['username'],
      map['email'],
      map['role'].toString(),
      map['image'] != null ? map['image'] : '',
    );
  }
}
