import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utilities/view_state.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../services/base/failure.dart';
import '../../../services/navigation_service.dart';
import '../../../services/snackbar_service.dart';
import '../states/update_password_state.dart';

class UpdatePasswordNotifier extends StateNotifier<UpdatePasswordState> {
  UpdatePasswordNotifier(this._ref) : super(UpdatePasswordState.initial());

  final Ref _ref;

  void toggleOldPasswordVisibility() =>
      state = state.copyWith(oldPasswordVisible: !state.oldPasswordVisible);

  void toggleNewPasswordVisibility() =>
      state = state.copyWith(newPasswordVisible: !state.newPasswordVisible);

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(viewState: ViewState.loading);

    try {
      await _ref.read(authenticationRepository).updatePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      _ref.read(navigationService).navigateBack();

      _ref.read(snackbarService).showSuccessSnackBar('Password Update Successful');
    } on Failure catch (ex) {
      _ref.read(navigationService).navigateBack();

      _ref.read(snackbarService).showErrorSnackBar(ex.message);
    } finally {
      state = state.copyWith(viewState: ViewState.idle);
    }
  }
}

final updatePasswordNotifierProvider = StateNotifierProvider.autoDispose<
    UpdatePasswordNotifier, UpdatePasswordState>(
  (ref) => UpdatePasswordNotifier(ref),
);
