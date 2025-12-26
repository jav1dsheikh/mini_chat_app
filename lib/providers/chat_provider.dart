import 'package:flutter/material.dart';
import '../models/user.dart';

class ChatProvider extends ChangeNotifier {
  final List<User> _users = [
    User(
      id: '1',
      name: 'Javid Sheikh',
      color: Colors.blueAccent,
      isOnline: true,
      lastMessage: "Hey! How's the project going?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    User(
      id: '2',
      name: 'Amit Verma',
      color: Colors.green,
      isOnline: false,
      lastSeen: '2 mins ago',
      lastMessage: "I'll check the PR in a bit.",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    User(
      id: '3',
      name: 'Priya Singh',
      color: Colors.purple,
      isOnline: true,
      lastMessage: "Can we reschedule the meeting?",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 5,
    ),
    User(
      id: '4',
      name: 'Neha Gupta',
      color: Colors.orange,
      isOnline: false,
      lastSeen: '10 mins ago',
      lastMessage: "Did you see the new mockups?",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    User(
      id: '5',
      name: 'Rohan Mehta',
      color: Colors.redAccent,
      isOnline: true,
      lastMessage: "Approved.",
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    User(
      id: '6',
      name: 'Ankit Patel',
      color: Colors.teal,
      isOnline: false,
      lastSeen: '1 hour ago',
      lastMessage: "Lunch?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    User(id: '7', name: 'Pooja Iyer', color: Colors.pink, isOnline: true),
    User(
      id: '8',
      name: 'Sandeep Malhotra',
      color: Colors.indigo,
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
      color: Colors.cyan,
      isOnline: true,
      lastMessage: "Let's deploy on Friday.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
    ),
    User(
      id: '10',
      name: 'Sarah Connor',
      color: Colors.deepOrange,
      isOnline: false,
      lastSeen: '3 days ago',
      lastMessage: "I'll be back.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 1,
    ),
    User(
      id: '11',
      name: 'Bruce Wayne',
      color: Colors.black87,
      isOnline: true,
      lastMessage: "I'm Batman.",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 5)),
    ),
    User(
      id: '12',
      name: 'Clark Kent',
      color: Colors.blue,
      isOnline: false,
      lastSeen: '1 week ago',
      lastMessage: "Up, up and away!",
      lastMessageTime: DateTime.now().subtract(const Duration(days: 7)),
    ),
    User(
      id: '13',
      name: 'Diana Prince',
      color: Colors.amber,
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
      color: Colors.primaries[uniqueName.length % Colors.primaries.length],
      isOnline: true,
    );

    _users.add(newUser);
    notifyListeners();
    return newUser;
  }
}
