import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/services_providers.dart';

// Stream of auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user (nullable)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// Current user ID (throws if not logged in)
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) throw Exception('Not authenticated');
  return user.uid;
});

// Auth actions notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
        (ref) => AuthNotifier(ref));

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref
          .read(authServiceProvider)
          .signInWithEmail(email: email, password: password),
    );
  }

  Future<void> registerWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref
          .read(authServiceProvider)
          .registerWithEmail(email: email, password: password),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref.read(authServiceProvider).signInWithGoogle(),
    );
  }

  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref.read(authServiceProvider).signInWithApple(),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref
          .read(authServiceProvider)
          .sendPasswordResetEmail(email),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref.read(authServiceProvider).signOut(),
    );
  }

  Future<void> deleteAccount() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _ref.read(authServiceProvider).deleteAccount(),
    );
  }
}
