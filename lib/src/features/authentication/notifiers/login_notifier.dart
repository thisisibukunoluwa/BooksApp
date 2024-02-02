import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/routes.dart';
import '../../../core/utilities/view_state.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../services/base/failure.dart';
import '../../../services/navigation_service.dart';
import '../../../services/snackbar_service.dart';
import '../states/login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._ref) : super(LoginState.initial());

  final Ref _ref;

  void togglePasswordVisibility() =>
      state = state.copyWith(passwordVisible: !state.passwordVisible);

  Future<void> loginUser({
    required String emailAddress,
    required String password,
  }) async {
    state = state.copyWith(viewState: ViewState.loading);

    try {
      await _ref.read(authenticationRepository).login(
        emailAddress: emailAddress.trim(),
        password: password,
      );

      _ref.read(navigationService).navigateOffNamed(Routes.home);
    } on Failure catch (ex) {
      _ref.read(snackbarService).showErrorSnackBar(ex.message);
    } finally {
      state = state.copyWith(viewState: ViewState.idle);
    }
  }

  Future<void> loginUserWithGoogle() async {
    try {
      final user = await _ref.read(authenticationRepository).loginWithGoogle();

      if (user != null) {
        _ref.read(navigationService).navigateOffNamed(Routes.home);
      } else {
        _ref.read(snackbarService).showErrorSnackBar('No email selected');
      }
    } on Failure catch (ex) {
      _ref.read(snackbarService).showErrorSnackBar(ex.message);
    } finally {
      state = state.copyWith(viewState: ViewState.idle);
    }
  }

  void navigateToRegister() {
    _ref.read(navigationService).navigateToNamed(Routes.register);
  }
}

final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref),
);
