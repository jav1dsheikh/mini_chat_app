import 'package:flutter/material.dart';
import '../models/user.dart';

class ChatProvider extends ChangeNotifier {
  final List<User> _users = [
    User(
      id: '1',
      name: 'Javid Sheikh',
      color: Colors.blueAccent,
      isOnline: true,
    ),
    User(
      id: '2',
      name: 'Amit Verma',
      color: Colors.green,
      isOnline: false,
      lastSeen: '2 mins ago',
    ),
    User(id: '3', name: 'Priya Singh', color: Colors.purple, isOnline: true),
    User(
      id: '4',
      name: 'Neha Gupta',
      color: Colors.orange,
      isOnline: false,
      lastSeen: '10 mins ago',
    ),
    User(id: '5', name: 'Rohan Mehta', color: Colors.redAccent, isOnline: true),
    User(
      id: '6',
      name: 'Ankit Patel',
      color: Colors.teal,
      isOnline: false,
      lastSeen: '1 hour ago',
    ),
    User(id: '7', name: 'Pooja Iyer', color: Colors.pink, isOnline: true),
    User(
      id: '8',
      name: 'Sandeep Malhotra',
      color: Colors.indigo,
      isOnline: false,
      lastSeen: 'Yesterday',
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
