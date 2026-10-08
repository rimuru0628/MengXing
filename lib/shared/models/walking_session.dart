import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TrackingMethod { automatic, manual, healthApi }

class WalkingSession {
  final String walkId;
  final String date; // yyyy-MM-dd
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int steps;
  final double distanceKm;
  final double paceMinPerKm;
  final double calories;
  final TrackingMethod trackingMethod;
  final List<LatLng>? gpsRoute;
  final bool isActive;

  const WalkingSession({
    required this.walkId,
    required this.date,
    required this.startTime,
    this.endTime,
    this.durationSeconds = 0,
    this.steps = 0,
    this.distanceKm = 0.0,
    this.paceMinPerKm = 0.0,
    this.calories = 0.0,
    this.trackingMethod = TrackingMethod.manual,
    this.gpsRoute,
    this.isActive = false,
  });

  factory WalkingSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    List<LatLng>? route;
    if (data['gpsRoute'] != null) {
      route = (data['gpsRoute'] as List).map((p) {
        final point = p as Map<String, dynamic>;
        return LatLng(
          (point['lat'] as num).toDouble(),
          (point['lng'] as num).toDouble(),
        );
      }).toList();
    }
    return WalkingSession(
      walkId: doc.id,
      date: data['date'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      durationSeconds: data['durationSeconds'] ?? 0,
      steps: data['steps'] ?? 0,
      distanceKm: (data['distanceKm'] as num?)?.toDouble() ?? 0.0,
      paceMinPerKm: (data['paceMinPerKm'] as num?)?.toDouble() ?? 0.0,
      calories: (data['calories'] as num?)?.toDouble() ?? 0.0,
      trackingMethod: TrackingMethod.values.firstWhere(
        (t) => t.name == data['trackingMethod'],
        orElse: () => TrackingMethod.manual,
      ),
      gpsRoute: route,
      isActive: false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'date': date,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
        'durationSeconds': durationSeconds,
        'steps': steps,
        'distanceKm': distanceKm,
        'paceMinPerKm': paceMinPerKm,
        'calories': calories,
        'trackingMethod': trackingMethod.name,
        'gpsRoute': gpsRoute
            ?.map((p) => {'lat': p.latitude, 'lng': p.longitude})
            .toList(),
      };

  WalkingSession copyWith({
    DateTime? endTime,
    int? durationSeconds,
    int? steps,
    double? distanceKm,
    double? paceMinPerKm,
    double? calories,
    List<LatLng>? gpsRoute,
    bool? isActive,
  }) =>
      WalkingSession(
        walkId: walkId,
        date: date,
        startTime: startTime,
        endTime: endTime ?? this.endTime,
        durationSeconds: durationSeconds ?? this.durationSeconds,
        steps: steps ?? this.steps,
        distanceKm: distanceKm ?? this.distanceKm,
        paceMinPerKm: paceMinPerKm ?? this.paceMinPerKm,
        calories: calories ?? this.calories,
        trackingMethod: trackingMethod,
        gpsRoute: gpsRoute ?? this.gpsRoute,
        isActive: isActive ?? this.isActive,
      );
}
