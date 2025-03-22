
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  SignupState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  SignupState copyWith({bool? isLoading, String? error}) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final signUpStateProvider = StateNotifierProvider<SignUpStateNotifier, SignupState>(
      (ref) => SignUpStateNotifier(),
);

class SignUpStateNotifier extends StateNotifier<SignupState> {
  SignUpStateNotifier() : super(SignupState());

  void setLoading(bool value) => state = state.copyWith(isLoading: value);
  void setError(String? error) => state = state.copyWith(error: error);
}
