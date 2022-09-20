import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? number;
  String? password;

  Users({
    this.id,
    this.email,
    this.name,
    this.number,
    this.password,
  });
  Users.fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> data =
        jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>;
    id = snapshot.key;
    email = data['email'];
    name = data['name'];
    number = data['number'];
    password = data['password'];
  }
}
