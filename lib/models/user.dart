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
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  String get initials {
    if (name.isEmpty) return "";
    return name[0].toUpperCase();
  }
}
