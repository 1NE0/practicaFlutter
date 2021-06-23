import 'dart:convert';
import 'package:flutter/material.dart';

class User {
  final String name;
  final int age;
  final int count;

  User(this.name, this.age, this.count);

  User.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        age = json['age'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'name': name, 'age': age, 'count': count};
}
