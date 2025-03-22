import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:realtime_chat_app/provider/auth_provider.dart';
import 'package:realtime_chat_app/provider/navigation_provider.dart';

final authViewModelProvider = Provider((ref) => AuthViewModel(ref));

class AuthViewModel {
  AuthViewModel(this._ref);

  final Ref _ref;

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _ref.read(authProvide.notifier).state = userCredential.user?.uid;
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _ref.read(authProvide.notifier).state = userCredential.user?.uid;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut()async{
    await FirebaseAuth.instance.signOut();
    _ref.read(authProvide.notifier).state=null;
    _ref.read(navigationProvider.notifier).state=AppScreen.login;

  }

}
