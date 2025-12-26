import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mini_chat_application/providers/chat_provider.dart';
import 'chat_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ChatProvider chatProvider;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    chatProvider = ChatProvider(client: mockClient, replyDelay: Duration.zero);
  });

  group('ChatProvider Unit Tests', () {
    test('sendMessage adds a message to the list', () async {
      const messageText = 'Hello Test';

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('{"comments": []}', 200));

      await chatProvider.sendMessage(messageText);

      expect(chatProvider.messages.length, 1);
      expect(chatProvider.messages.first.text, messageText);
      expect(chatProvider.messages.first.isMe, true);
    });

    test('sendMessage sets errorMessage on server error', () async {
      const messageText = 'Error Test';

      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

      await chatProvider.sendMessage(messageText);

      await Future.delayed(Duration.zero);

      expect(chatProvider.errorMessage, contains("Server error: 500"));
    });
  });
}
