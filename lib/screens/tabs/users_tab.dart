import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_theme.dart';
import '../chat_screen.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              final newUser = chatProvider.addRandomUser();
              final height = MediaQuery.of(context).size.height;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "${newUser.name} added Successfully",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.textMain.withAlpha(150),
                  margin: EdgeInsets.only(
                    bottom: height - 180,
                    left: 20,
                    right: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          );
        },
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          final users = chatProvider.users;
          return CustomScrollView(
            key: const PageStorageKey('users_list'),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final user = users[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.avatarGradientStart,
                                AppColors.avatarGradientEnd,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user.initials,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        if (user.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.onlineIndicator,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textMain,
                      ),
                    ),
                    subtitle: Text(
                      user.isOnline ? "Online" : (user.lastSeen ?? ''),
                      style: TextStyle(
                        color: user.isOnline
                            ? AppColors.textMain
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(user: user),
                        ),
                      );
                    },
                  );
                }, childCount: users.length),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          );
        },
      ),
    );
  }
}
