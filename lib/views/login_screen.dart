import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/provider/text_input_provider.dart';
import 'package:realtime_chat_app/viewmodels/auth_viewmodel.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = ref.watch(loginPasswordVisibleProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) =>
                  ref.read(loginEmailProvider.notifier).state = value,
              decoration: InputDecoration(label: Text('Email')),
              keyboardType: TextInputType.text,
            ),
            TextField(
              onChanged: (value) =>
                  ref.read(loginPasswordProvider.notifier).state = value,
              decoration: InputDecoration(
                  label: Text('Password'),
                  suffixIcon: IconButton(
                      onPressed: () => ref
                          .read(loginPasswordVisibleProvider.notifier)
                          .state = !isPasswordVisible,
                      icon: Icon(isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off))),
              obscureText: !isPasswordVisible,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final email = ref.read(loginEmailProvider);
                  final password = ref.read(loginPasswordProvider);
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in All Field!")));
                    return;
                  }
                  try {
                    await ref
                        .read(authViewModelProvider)
                        .signIn(email, password);
                    if (ref.read(authProvide) != null) {
                      ref.read(navigationProvider.notifier).state =
                          AppScreen.chatRoomList;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Successfully")));
                    }
                    ref.read(loginEmailProvider.notifier).state = '';
                    ref.read(loginPasswordProvider.notifier).state = '';
                    ref.read(loginPasswordVisibleProvider.notifier).state =false;
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login Failed $e")));
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
