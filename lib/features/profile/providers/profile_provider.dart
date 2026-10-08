import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';

final profileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  return ref.watch(firestoreServiceProvider).profileStream(uid);
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<void>>(
        (ref) => ProfileNotifier(ref));

class ProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ProfileNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> createProfile(UserProfile profile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final uid = _ref.read(currentUserIdProvider);
      await _ref.read(firestoreServiceProvider).createProfile(uid, profile);
    });
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final uid = _ref.read(currentUserIdProvider);
      await _ref.read(firestoreServiceProvider).updateProfile(uid, data);
    });
  }

  Future<void> updateAvatar(String avatarUrl) =>
      updateProfile({'avatarUrl': avatarUrl});
}
