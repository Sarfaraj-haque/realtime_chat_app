import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/provider/signup_state_provider.dart';
import 'package:realtime_chat_app/provider/text_input_provider.dart';
import 'package:realtime_chat_app/viewmodels/auth_viewmodel.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupState = ref.watch(signUpStateProvider);
    final isPasswordVisible = ref.watch(signupPasswordVisibleProvider);
    final showConfirmPassword = ref.watch(signupPasswordVisibleProvider);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (signupState.error != null)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                signupState.error!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextField(
            keyboardType: TextInputType.text,
            onChanged: (value) =>
                ref.read(signupEmailProvider.notifier).state = value,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            keyboardType: TextInputType.text,
            onChanged: (value) =>
                ref.read(signupPasswordProvider.notifier).state = value,
            decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                    onPressed: () {
                      ref.read(signupPasswordVisibleProvider.notifier).state =
                          !isPasswordVisible;
                    },
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off))),
            obscureText: !isPasswordVisible,
          ),
          TextField(
            keyboardType: TextInputType.text,
            onChanged: (value) =>
                ref.read(signupConfirmPasswordProvider.notifier).state = value,
            decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: IconButton(
                    onPressed: () {
                      ref.read(signupPasswordVisibleProvider.notifier).state =
                          !showConfirmPassword;
                    },
                    icon: Icon(showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off))),
            obscureText: !showConfirmPassword,
          ),
          SizedBox(
            height: 20,
          ),
          signupState.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    final email = ref.read(signupEmailProvider);
                    final password = ref.read(signupPasswordProvider);
                    final confirmPassword =
                        ref.read(signupConfirmPasswordProvider);

                    if (email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      ref
                          .read(signUpStateProvider.notifier)
                          .setError('Please fill in all Fields');
                    }
                    if (password != confirmPassword) {
                      ref
                          .read(signUpStateProvider.notifier)
                          .setError('Password does not match');
                    }

                    ref.read(signUpStateProvider.notifier).setLoading(true);
                    ref.read(signUpStateProvider.notifier).setError(null);
                    try {
                      await ref
                          .read(authViewModelProvider)
                          .signUp(email, password);

                      if (ref.read(authProvide) != null) {
                        ref.read(navigationProvider.notifier).state =
                            AppScreen.chatRoomList;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful")));

                        ref.read(signupEmailProvider.notifier).state = '';
                        ref.read(signupPasswordProvider.notifier).state = '';
                        ref.read(signupConfirmPasswordProvider.notifier).state = '';
                        ref.read(signupPasswordVisibleProvider.notifier).state = false;
                        ref.read(signupPasswordVisibleProvider.notifier).state = false;
                      }
                    } catch (e) {
                      ref
                          .read(signUpStateProvider.notifier)
                          .setError(e.toString());
                    } finally {
                      ref.read(signUpStateProvider.notifier).setLoading(false);
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
