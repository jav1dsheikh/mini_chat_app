import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';

import '../../theme/app_theme.dart';
import '../chat_screen.dart';

class ChatHistoryTab extends StatefulWidget {
  const ChatHistoryTab({super.key});

  @override
  State<ChatHistoryTab> createState() => _ChatHistoryTabState();
}

class _ChatHistoryTabState extends State<ChatHistoryTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final historyUsers = chatProvider.chatHistoryUsers;

        if (historyUsers.isEmpty) {
          return const Center(
            child: Text(
              "No recent chats",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          );
        }

        return CustomScrollView(
          controller: _scrollController,
          key: const PageStorageKey('chat_history_list'),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final user = historyUsers[index];
                final isLast = index == historyUsers.length - 1;

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Stack(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.chatAvatarGradientStart,
                                  AppColors.chatAvatarGradientEnd,
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
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          if (user.isOnline)
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                width: 14,
                                height: 14,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textMain,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          user.lastMessage ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(user.lastMessageTime),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (user.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.unreadBadge,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                user.unreadCount.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(user: user),
                          ),
                        );
                      },
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 72,
                        endIndent: 16,
                        color: AppColors.border,
                      ),
                  ],
                );
              }, childCount: historyUsers.length),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
          ],
        );
      },
    );
  }
}
