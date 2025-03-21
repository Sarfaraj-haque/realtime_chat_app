import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/viewmodels/auth_viewmodel.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(label: Text('Email')),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(label: Text('Password')),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(authViewModelProvider)
                      .singIn(_emailController.text, _passwordController.text);
                  if (ref.read(authProvide) != null) {
                    ref.read(navigationProvider.notifier).state =
                        AppScreen.chatRoomList;
                  }
                },
                child: Text("Login")),
            TextButton(
                onPressed: () {
                  ref.read(navigationProvider.notifier).state =
                      AppScreen.signup;
                },
                child: Text("Signup")),
          ],
        ),
      ),
    );
  }
}
