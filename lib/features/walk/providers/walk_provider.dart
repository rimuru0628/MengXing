import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/utils/fitness_utils.dart';
import '../../../shared/models/walking_session.dart';
import '../../../shared/providers/services_providers.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/providers/home_provider.dart';

enum WalkState { idle, active, paused, finished }

class WalkSessionState {
  final WalkState status;
  final WalkingSession? session;
  final int elapsedSeconds;
  final int steps;
  final double distanceKm;
  final double paceMinPerKm;
  final double calories;
  final List<LatLng> route;
  final bool gpsEnabled;

  const WalkSessionState({
    this.status = WalkState.idle,
    this.session,
    this.elapsedSeconds = 0,
    this.steps = 0,
    this.distanceKm = 0.0,
    this.paceMinPerKm = 0.0,
    this.calories = 0.0,
    this.route = const [],
    this.gpsEnabled = false,
  });

  WalkSessionState copyWith({
    WalkState? status,
    WalkingSession? session,
    int? elapsedSeconds,
    int? steps,
    double? distanceKm,
    double? paceMinPerKm,
    double? calories,
    List<LatLng>? route,
    bool? gpsEnabled,
  }) =>
      WalkSessionState(
        status: status ?? this.status,
        session: session ?? this.session,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
        steps: steps ?? this.steps,
        distanceKm: distanceKm ?? this.distanceKm,
        paceMinPerKm: paceMinPerKm ?? this.paceMinPerKm,
        calories: calories ?? this.calories,
        route: route ?? this.route,
        gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      );
}

final walkNotifierProvider =
    StateNotifierProvider<WalkNotifier, WalkSessionState>(
        (ref) => WalkNotifier(ref));

class WalkNotifier extends StateNotifier<WalkSessionState> {
  final Ref _ref;
  Timer? _timer;
  StreamSubscription<Position>? _locationSub;
  final _uuid = const Uuid();

  WalkNotifier(this._ref) : super(const WalkSessionState());

  void startWalk({bool useGps = false}) {
    final sessionId = 'walk_${_uuid.v4()}';
    final now = DateTime.now();
    final session = WalkingSession(
      walkId: sessionId,
      date: AppDateUtils.toDateKey(now),
      startTime: now,
      trackingMethod: TrackingMethod.manual,
      isActive: true,
    );

    state = WalkSessionState(
      status: WalkState.active,
      session: session,
      gpsEnabled: useGps,
    );

    _startTimer();
    if (useGps) _startGpsTracking();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == WalkState.active) {
        final newElapsed = state.elapsedSeconds + 1;
        // Estimate distance from steps
        final dist = FitnessUtils.stepsToKm(state.steps);
        final pace = FitnessUtils.calculatePace(newElapsed, dist);
        state = state.copyWith(
          elapsedSeconds: newElapsed,
          distanceKm: dist,
          paceMinPerKm: pace,
        );
      }
    });
  }

  void _startGpsTracking() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = state.copyWith(gpsEnabled: false);
      return;
    }
    const settings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _locationSub = Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      if (state.status == WalkState.active) {
        final newPoint = LatLng(pos.latitude, pos.longitude);
        final route = [...state.route, newPoint];

        // Calculate distance from GPS
        double gpsDistance = 0;
        if (route.length > 1) {
          for (int i = 1; i < route.length; i++) {
            gpsDistance += Geolocator.distanceBetween(
              route[i - 1].latitude,
              route[i - 1].longitude,
              route[i].latitude,
              route[i].longitude,
            );
          }
        }
        final km = gpsDistance / 1000.0;
        final pace = FitnessUtils.calculatePace(state.elapsedSeconds, km);
        state = state.copyWith(
          route: route,
          distanceKm: km,
          paceMinPerKm: pace,
        );
      }
    });
  }

  void addSteps(int steps) {
    if (state.status != WalkState.active) return;
    final totalSteps = state.steps + steps;
    state = state.copyWith(steps: totalSteps);
  }

  void pause() {
    if (state.status != WalkState.active) return;
    state = state.copyWith(status: WalkState.paused);
  }

  void resume() {
    if (state.status != WalkState.paused) return;
    state = state.copyWith(status: WalkState.active);
  }

  Future<WalkingSession?> stopWalk({double weightKg = 70}) async {
    _timer?.cancel();
    _locationSub?.cancel();

    final now = DateTime.now();
    final calories =
        FitnessUtils.estimateCaloriesWalking(
          weightKg: weightKg,
          durationSeconds: state.elapsedSeconds,
        );

    final finished = state.session?.copyWith(
      endTime: now,
      durationSeconds: state.elapsedSeconds,
      steps: state.steps,
      distanceKm: state.distanceKm,
      paceMinPerKm: state.paceMinPerKm,
      calories: calories,
      gpsRoute: state.route.isEmpty ? null : state.route,
      isActive: false,
    );

    state = state.copyWith(
      status: WalkState.finished,
      calories: calories,
      session: finished,
    );

    return finished;
  }

  Future<void> saveSession(WalkingSession session) async {
    final uid = _ref.read(currentUserIdProvider);
    await _ref.read(firestoreServiceProvider).saveWalkingSession(uid, session);
    // Update daily activity walk count
    await _ref.read(activitySyncProvider.notifier).incrementWalkCount();
    reset();
  }

  void reset() {
    _timer?.cancel();
    _locationSub?.cancel();
    state = const WalkSessionState();
  }

  // ─── Today's walk sessions ────────────────────────────────────────
  Future<List<WalkingSession>> getTodayWalks() async {
    final uid = _ref.read(currentUserIdProvider);
    return _ref
        .read(firestoreServiceProvider)
        .getWalkingSessionsForDate(uid, DateTime.now());
  }
}

// Walk history provider
final walkHistoryProvider =
    FutureProvider.family<List<WalkingSession>, DateRange>((ref, range) async {
  final uid = ref.watch(currentUserIdProvider);
  return ref
      .read(firestoreServiceProvider)
      .getWalkingSessionsForRange(uid, range.start, range.end);
});

final todayWalksProvider = FutureProvider<List<WalkingSession>>((ref) async {
  final uid = ref.watch(currentUserIdProvider);
  return ref
      .read(firestoreServiceProvider)
      .getWalkingSessionsForDate(uid, DateTime.now());
});

class DateRange {
  final DateTime start;
  final DateTime end;
  const DateRange(this.start, this.end);
}
