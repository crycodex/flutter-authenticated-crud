import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return '''
      LoginFormState:
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      email: ${email.value},
      password: ${password.value},
    ''';
  }
}

//notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(String, String) loginUser;

  LoginFormNotifier({required this.loginUser}) : super(LoginFormState());

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([state.email, newPassword]));
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) return;
    print(state);
    state = state.copyWith(isPosting: true);
    await loginUser(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(loginUser: loginUserCallback);
});
