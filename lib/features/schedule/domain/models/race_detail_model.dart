class RaceDetailModel {
  final String raceName;
  final String circuitName;
  final String dateRange;
  final String lengthKm;
  final int laps;
  final int corners;
  final String maxSpeed;
  final String elevation;
  final List<WeekendSession> sessions;

  const RaceDetailModel({
    required this.raceName,
    required this.circuitName,
    required this.dateRange,
    required this.lengthKm,
    required this.laps,
    required this.corners,
    required this.maxSpeed,
    required this.elevation,
    required this.sessions,
  });
}

class WeekendSession {
  final String day;
  final String dayOfWeek;
  final String title;
  final String timeRange;

  const WeekendSession({
    required this.day,
    required this.dayOfWeek,
    required this.title,
    required this.timeRange,
  });
}