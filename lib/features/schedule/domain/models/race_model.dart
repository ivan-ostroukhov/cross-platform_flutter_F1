import 'package:intl/intl.dart';

class RaceModel {
  final String round;
  final String raceName;
  final String circuitId;
  final String circuitName;
  final String locality;
  final String country;
  final DateTime? date;
  final String dateRange;
  final bool isCompleted;
  final List<PodiumDriver>? podium;
  final List<RaceSession> sessions;

  const RaceModel({
    required this.round,
    required this.raceName,
    required this.circuitId,
    this.circuitName = '',
    required this.locality,
    required this.country,
    this.date,
    required this.dateRange,
    required this.isCompleted,
    this.podium,
    this.sessions = const [],
  });

  factory RaceModel.fromJson(Map<String, dynamic> json, {List<PodiumDriver>? podium}) {
    final circuit = json['Circuit'] as Map<String, dynamic>? ?? {};
    final location = circuit['Location'] as Map<String, dynamic>? ?? {};

    DateTime? parseUtc(String? d, String? t) {
      if (d == null) return null;
      final iso = t != null ? '${d}T$t' : d;
      return DateTime.tryParse(iso)?.toLocal();
    }

    final raceDate = parseUtc(json['date'] as String?, json['time'] as String?);
    final now = DateTime.now();
    final isCompleted = raceDate != null ? raceDate.isBefore(now) : false;

    final parsedSessions = <RaceSession>[];

    void addSession(String title, Map<String, dynamic>? sessionJson, Duration duration) {
      if (sessionJson == null) return;
      final start = parseUtc(sessionJson['date'] as String?, sessionJson['time'] as String?);
      if (start != null) {
        parsedSessions.add(
          RaceSession(
            title: title,
            startTime: start,
            endTime: start.add(duration),
          ),
        );
      }
    }

    addSession('Practice 1', json['FirstPractice'] as Map<String, dynamic>?, const Duration(minutes: 60));
    addSession('Practice 2', json['SecondPractice'] as Map<String, dynamic>?, const Duration(minutes: 60));
    addSession('Practice 3', json['ThirdPractice'] as Map<String, dynamic>?, const Duration(minutes: 60));
    addSession('Sprint Qualifying', json['SprintQualifying'] as Map<String, dynamic>?, const Duration(minutes: 44));
    addSession('Sprint', json['Sprint'] as Map<String, dynamic>?, const Duration(minutes: 60));
    addSession('Qualifying', json['Qualifying'] as Map<String, dynamic>?, const Duration(minutes: 60));

    if (raceDate != null) {
      parsedSessions.add(
        RaceSession(
          title: 'Race',
          startTime: raceDate,
          endTime: raceDate.add(const Duration(hours: 2)),
        ),
      );
    }

    parsedSessions.sort((a, b) => a.startTime.compareTo(b.startTime));

    String formattedRange = '';
    if (parsedSessions.isNotEmpty) {
      final start = parsedSessions.first.startTime;
      final end = parsedSessions.last.startTime;
      final startDay = DateFormat('dd').format(start);
      final endDay = DateFormat('dd').format(end);
      final month = DateFormat('MMM', 'ru').format(end);
      formattedRange = '$startDay - $endDay $month';
    } else if (raceDate != null) {
      formattedRange = DateFormat('dd MMM', 'ru').format(raceDate);
    }

    return RaceModel(
      round: json['round'] as String? ?? '0',
      raceName: json['raceName'] as String? ?? '',
      circuitId: circuit['circuitId'] as String? ?? '',
      circuitName: circuit['circuitName'] as String? ?? '',
      locality: location['locality'] as String? ?? '',
      country: location['country'] as String? ?? '',
      date: raceDate,
      dateRange: formattedRange,
      isCompleted: isCompleted,
      podium: podium,
      sessions: parsedSessions,
    );
  }
}

class RaceSession {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  const RaceSession({
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  String get day => DateFormat('dd').format(startTime);
  String get dayOfWeek => DateFormat('E', 'ru').format(startTime).toUpperCase();
  String get timeRange =>
      '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}';
}

class PodiumDriver {
  final String code;
  final String teamName;
  final int position;

  const PodiumDriver({
    required this.code,
    required this.teamName,
    this.position = 0,
  });

  factory PodiumDriver.fromJson(Map<String, dynamic> json) {
    final driver = json['Driver'] as Map<String, dynamic>? ?? {};
    final constructor = json['Constructor'] as Map<String, dynamic>? ?? {};

    return PodiumDriver(
      code: driver['code'] as String? ??
          (driver['familyName'] as String? ?? '').padRight(3).substring(0, 3).toUpperCase(),
      teamName: constructor['name'] as String? ?? '',
      position: int.tryParse(json['position'] as String? ?? '0') ?? 0,
    );
  }
}