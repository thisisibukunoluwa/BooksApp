import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/routes.dart';
import '../../../core/utilities/view_state.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../services/base/failure.dart';
import '../../../services/navigation_service.dart';
import '../../../services/snackbar_service.dart';
import '../states/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._ref) : super(ProfileState.initial());

  final Ref _ref;

  User get user => _ref.read(authenticationRepository).currentUser!;

  Future<void> logoutUser() async {
    await _ref.read(authenticationRepository).logout();

    _ref.read(navigationService).navigateOffAllNamed(
      Routes.login,
      (_) => false,
    );
  }

  Future<void> deleteUser() async {
    try {
      state = state.copyWith(viewState: ViewState.loading);

      final message = await _ref.read(authenticationRepository).deleteUser();

      _ref.read(navigationService).navigateOffAllNamed(
        Routes.login,
        (_) => false,
      );

      _ref.read(snackbarService).showSuccessSnackBar(message);
    } on Failure catch (f) {
      _ref.read(snackbarService).showErrorSnackBar(f.message);
    } finally {
      state = state.copyWith(viewState: ViewState.idle);
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(ref),
);
