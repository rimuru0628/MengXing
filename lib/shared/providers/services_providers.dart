import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase/auth_service.dart';
import '../../services/firebase/firestore_service.dart';
import '../../services/health/health_service.dart';
import '../../services/local_storage/local_storage_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/ai/ai_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

final healthServiceProvider = Provider<HealthService>((ref) => HealthService());

final localStorageProvider =
    Provider<LocalStorageService>((ref) => LocalStorageService());

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final aiServiceProvider = Provider<AiService>((ref) => AiService());
