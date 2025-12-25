import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final Color color;
  final bool isOnline;
  final String? lastSeen;

  User({
    required this.id,
    required this.name,
    required this.color,
    this.isOnline = false,
    this.lastSeen,
  });

  String get initials {
    if (name.isEmpty) return "";
    return name[0].toUpperCase();
  }
}
