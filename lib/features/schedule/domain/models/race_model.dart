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
  });

  factory RaceModel.fromJson(Map<String, dynamic> json, {List<PodiumDriver>? podium}) {
    final circuit = json['Circuit'] as Map<String, dynamic>? ?? {};
    final location = circuit['Location'] as Map<String, dynamic>? ?? {};

    DateTime? raceDate;
    final dateStr = json['date'] as String?;
    final timeStr = json['time'] as String?;
    if (dateStr != null) {
      final isoString = timeStr != null ? '${dateStr}T$timeStr' : dateStr;
      raceDate = DateTime.tryParse(isoString);
    }

    final now = DateTime.now();
    final isCompleted = raceDate != null ? raceDate.isBefore(now) : false;

    String formattedDateRange = '';
    if (raceDate != null) {
      final day = raceDate.day.toString().padLeft(2, '0');
      const months = [
        'Янв.', 'Фев.', 'Мар.', 'Апр.', 'Май', 'Июн.',
        'Июл.', 'Авг.', 'Сен.', 'Окт.', 'Нояб.', 'Дек.'
      ];
      final month = months[raceDate.month - 1];
      formattedDateRange = '$day $month';
    }

    return RaceModel(
      round: json['round'] as String? ?? '0',
      raceName: json['raceName'] as String? ?? '',
      circuitId: circuit['circuitId'] as String? ?? '',
      circuitName: circuit['circuitName'] as String? ?? '',
      locality: location['locality'] as String? ?? '',
      country: location['country'] as String? ?? '',
      date: raceDate,
      dateRange: formattedDateRange,
      isCompleted: isCompleted,
      podium: podium,
    );
  }

  RaceModel copyWith({List<PodiumDriver>? podium}) {
    return RaceModel(
      round: round,
      raceName: raceName,
      circuitId: circuitId,
      circuitName: circuitName,
      locality: locality,
      country: country,
      date: date,
      dateRange: dateRange,
      isCompleted: isCompleted,
      podium: podium ?? this.podium,
    );
  }
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