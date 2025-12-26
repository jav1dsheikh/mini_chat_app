import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatProvider extends ChangeNotifier {
  final http.Client client;
  final Duration replyDelay;

  ChatProvider({
    http.Client? client,
    this.replyDelay = const Duration(seconds: 1),
  }) : client = client ?? http.Client();

  final List<User> _users = [
    User(
      id: '1',
      name: 'Javid Sheikh',
      color: AppColors.userAvatarColors[0],
      isOnline: true,
      lastMessage: "Hey! How's the project going?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    User(
      id: '2',
      name: 'Amit Verma',
      color: AppColors.userAvatarColors[1],
      isOnline: false,
      lastSeen: '2 mins ago',
      lastMessage: "I'll check the PR in a bit.",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    User(
      id: '3',
      name: 'Priya Singh',
      color: AppColors.userAvatarColors[2],
      isOnline: true,
      lastMessage: "Can we reschedule the meeting?",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 5,
    ),
    User(
      id: '4',
      name: 'Neha Gupta',
      color: AppColors.userAvatarColors[3],
      isOnline: false,
      lastSeen: '10 mins ago',
      lastMessage: "Did you see the new mockups?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    User(
      id: '5',
      name: 'Rohan Mehta',
      color: AppColors.userAvatarColors[4],
      isOnline: true,
      lastMessage: "Approved.",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    User(
      id: '6',
      name: 'Ankit Patel',
      color: AppColors.userAvatarColors[5],
      isOnline: false,
      lastSeen: '1 hour ago',
      lastMessage: "Lunch?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    User(
      id: '7',
      name: 'Pooja Iyer',
      color: AppColors.userAvatarColors[6],
      isOnline: true,
    ),
    User(
      id: '8',
      name: 'Sandeep Malhotra',
      color: AppColors.userAvatarColors[7],
      isOnline: false,
      lastSeen: 'Yesterday',
      lastMessage: "The design looks great!",
      lastMessageTime: DateTime.now().subtract(
        const Duration(days: 1, hours: 2),
      ),
    ),
    User(
      id: '9',
      name: 'Michael Chen',
      color: AppColors.userAvatarColors[8],
      isOnline: true,
      lastMessage: "Let's deploy on Friday.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
    ),
    User(
      id: '10',
      name: 'Sarah Connor',
      color: AppColors.userAvatarColors[9],
      isOnline: false,
      lastSeen: '3 days ago',
      lastMessage: "I'll be back.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 1,
    ),
    User(
      id: '11',
      name: 'Bruce Wayne',
      color: AppColors.userAvatarColors[10],
      isOnline: true,
      lastMessage: "I'm Batman.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 5)),
    ),
    User(
      id: '12',
      name: 'Clark Kent',
      color: AppColors.userAvatarColors[11],
      isOnline: false,
      lastSeen: '1 week ago',
      lastMessage: "Up, up and away!",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 7)),
    ),
    User(
      id: '13',
      name: 'Diana Prince',
      color: AppColors.userAvatarColors[12],
      isOnline: true,
      lastMessage: "Truth is power.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final List<String> _randomNames = [
    'Rahul Sharma',
    'Vikram Malhotra',
    'Aditya Roy',
    'Sneha Kapoor',
    'Manage Joshi',
    'Kavita Das',
    'Arjun Nair',
    'Zara Khan',
  ];

  List<User> get users => _users;

  List<User> get chatHistoryUsers =>
      _users.where((user) => user.lastMessage != null).toList();

  User addRandomUser() {
    final name = _randomNames[DateTime.now().second % _randomNames.length];
    final uniqueName = name;

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: uniqueName,
      color:
          AppColors.userAvatarColors[uniqueName.length %
              AppColors.userAvatarColors.length],
      isOnline: true,
    );

    _users.add(newUser);
    notifyListeners();
    return newUser;
  }

  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> setActiveChat(User user) async {
    _messages.clear();

    if (user.lastMessage != null) {
      _messages.add(
        ChatMessage(
          id: 'history_latest',
          text: user.lastMessage!,
          isMe: false,
          timestamp: user.lastMessageTime ?? DateTime.now(),
        ),
      );
    }

    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      timestamp: DateTime.now(),
    );

    _messages.insert(0, newMessage);
    notifyListeners();

    _getReply();
  }

  Future<void> _getReply() async {
    _isTyping = true;
    notifyListeners();

    await Future.delayed(replyDelay);

    try {
      final response = await client.get(
        Uri.parse(
          'https://dummyjson.com/comments?limit=1&skip=${Random().nextInt(100)}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final comments = data['comments'] as List;

        if (comments.isNotEmpty) {
          final comment = comments[0];
          final replyMessage = ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: comment['body'],
            isMe: false,
            timestamp: DateTime.now(),
          );
          _messages.insert(0, replyMessage);
        }
      } else {
        _errorMessage = "Server error: ${response.statusCode}";
      }
    } catch (_) {
      _errorMessage = "Failed to fetch reply. Please check your connection.";
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getDefinition(String word) async {
    final cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '');
    if (cleanWord.isEmpty) return null;

    try {
      final response = await client.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$cleanWord'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
