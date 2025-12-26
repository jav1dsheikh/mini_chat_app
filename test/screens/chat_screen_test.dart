import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_application/screens/chat_screen.dart';
import 'package:mini_chat_application/providers/chat_provider.dart';
import 'package:mini_chat_application/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../providers/chat_provider_test.mocks.dart';

void main() {
  late ChatProvider chatProvider;
  late MockClient mockClient;

  final testUser = User(
    id: '1',
    name: 'Test User',
    color: const Color(0xFF448AFF),
    isOnline: true,
  );

  setUp(() {
    mockClient = MockClient();
    chatProvider = ChatProvider(client: mockClient, replyDelay: Duration.zero);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<ChatProvider>.value(
        value: chatProvider,
        child: ChatScreen(user: testUser),
      ),
    );
  }

  group('ChatScreen Widget Tests', () {
    testWidgets('ChatScreen renders correctly with initial state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Tapping send adds a message bubble', (
      WidgetTester tester,
    ) async {
      when(
        mockClient.get(any),
      ).thenAnswer((_) async => http.Response('{"comments": []}', 200));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'Hello Widget');

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Hello Widget', findRichText: true), findsOneWidget);
    });
  });
}
