import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/utilities/view_state.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../services/base/failure.dart';
import '../../../services/navigation_service.dart';
import '../../../services/snackbar_service.dart';
import '../states/update_profile_state.dart';

class UpdateProfileNotifier extends StateNotifier<UpdateProfileState> {
  UpdateProfileNotifier(this._ref) : super(UpdateProfileState.initial());

  final Ref _ref;

  void togglePasswordVisibility() =>
      state = state.copyWith(passwordVisible: !state.passwordVisible);

  Future<void> updateProfile(String fullName) async {
    state = state.copyWith(viewState: ViewState.loading);

    try {
      await _ref.read(authenticationRepository).updateUser(fullName: fullName);

      _ref.read(navigationService).navigateBack();

      _ref.read(snackbarService).showSuccessSnackBar('Profile Update Successful');
    } on Failure catch (ex) {
      _ref.read(navigationService).navigateBack();

      _ref.read(snackbarService).showErrorSnackBar(ex.message);
    } finally {
      state = state.copyWith(viewState: ViewState.idle);
    }
  }
}

final updateProfileNotifierProvider = StateNotifierProvider.autoDispose<
    UpdateProfileNotifier, UpdateProfileState>(
  (ref) => UpdateProfileNotifier(ref),
);
