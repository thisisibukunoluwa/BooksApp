import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/routes.dart';
import '../../../repositories/authentication_repository.dart';
import '../../../services/navigation_service.dart';

class VerifyEmailNotifier extends StateNotifier<void> {
  VerifyEmailNotifier(this._ref) : super(null);

  final Ref _ref;

  Future<void> navigateToLogin() async {
    await _ref.read(authenticationRepository).logout();

    _ref.read(navigationService).navigateOffNamed(Routes.login);
  }
}

final verifyEmailNotifierProvider =
    StateNotifierProvider.autoDispose<VerifyEmailNotifier, void>(
  (ref) => VerifyEmailNotifier(ref),
);
