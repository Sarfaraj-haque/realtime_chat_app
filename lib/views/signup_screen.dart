import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/viewmodels/auth_viewmodel.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            keyboardType: TextInputType.text,
            controller: _emailController,
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _passwordController,
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await ref
                    .read(authViewModelProvider)
                    .signUp(_emailController.text, _passwordController.text);

                if (ref.read(authProvide) != null) {
                  ref.read(navigationProvider.notifier).state =
                      AppScreen.chatRoomList;
                }
              },
              child: Text("Signup")),
          TextButton(
            onPressed: () {
              ref.read(navigationProvider.notifier).state = AppScreen.login;
            },
            child: Text('Back to Login'),
          )
        ],
      ),
    );
  }
}
