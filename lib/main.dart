import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';
import 'package:realtime_chat_app/views/chat_room_list.dart';
import 'package:realtime_chat_app/views/login_screen.dart';
import 'package:realtime_chat_app/views/signup_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("🔥 Firebase initialized successfully!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScreen = ref.watch(navigationProvider);
    return MaterialApp(
      title: "Real-time Chat App",
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: buildScreen(currentScreen)),
    );
  }

  Widget buildScreen(AppScreen screen) {
    switch (screen) {
      case AppScreen.login:
        return LoginScreen();
      case AppScreen.signup:
        return SignupScreen();
      case AppScreen.chatRoomList:
        return ChatRoomListScreen();
    }
  }
}
