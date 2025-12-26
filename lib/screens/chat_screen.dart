import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import '../models/user.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatelessWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatProvider>(context, listen: false).setActiveChat(user);
    });

    final errorMessage = context.select<ChatProvider, String?>(
      (p) => p.errorMessage,
    );
    if (errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Provider.of<ChatProvider>(context, listen: false).clearError();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [user.color, user.color.withAlpha(200)],
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
                Text(
                  user.isOnline ? "Online" : "Offline",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.messages;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: messages.length + (chatProvider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (chatProvider.isTyping) {
                      if (index == 0) return _TypingIndicator(user: user);

                      final message = messages[index - 1];
                      return _MessageBubble(message: message, user: user);
                    }

                    final message = messages[index];
                    return _MessageBubble(message: message, user: user);
                  },
                );
              },
            ),
          ),
          const _ChatInputArea(),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final User user;

  const _MessageBubble({required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeString = DateFormat.jm().format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            _Avatar(user: user, size: 40),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primaryBlue
                        : AppColors.receiverBubble,
                    borderRadius: isMe
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                  ),
                  child: _InteractiveMessageText(
                    text: message.text,
                    style: TextStyle(
                      color: isMe ? AppColors.white : AppColors.textMain,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            _Avatar(user: user, isMe: true, size: 40),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final User user;
  final bool isMe;
  final double size;

  const _Avatar({required this.user, this.isMe = false, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isMe
              ? [AppColors.avatarGradientStart, AppColors.avatarGradientEnd]
              : [user.color, user.color.withAlpha(150)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          isMe ? "You" : user.initials,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMe ? 12 : 16,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final User user;

  const _TypingIndicator({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _Avatar(user: user, size: 40),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.receiverBubble,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: const Text(
              " Typing...",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputArea extends StatefulWidget {
  const _ChatInputArea();

  @override
  State<_ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<_ChatInputArea> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).sendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.avatarGradientStart,
                    AppColors.avatarGradientEnd,
                  ],
                ),
              ),
              child: const Icon(Icons.send, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveMessageText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _InteractiveMessageText({required this.text, required this.style});

  void _showDefinitionSheet(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: Provider.of<ChatProvider>(
            context,
            listen: false,
          ).getDefinition(word),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Definition not found for \"$word\"",
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textMain,
                      ),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data!;
            final wordText = data['word'] as String;
            final phonetic = data['phonetic'] as String? ?? '';
            final meanings = data['meanings'] as List;
            final firstMeaning = meanings.isNotEmpty ? meanings[0] : null;
            final partOfSpeech = firstMeaning?['partOfSpeech'] as String? ?? '';
            final definitions = firstMeaning?['definitions'] as List?;
            final definition = definitions != null && definitions.isNotEmpty
                ? definitions[0]['definition']
                : 'No definition available.';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      wordText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Text(
                  phonetic,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    partOfSpeech,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      definition,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textMain,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    final spans = <InlineSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      spans.add(
        TextSpan(
          text: word,
          style: style,
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () => _showDefinitionSheet(context, word),
        ),
      );
      if (i < words.length - 1) {
        spans.add(TextSpan(text: " ", style: style));
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
