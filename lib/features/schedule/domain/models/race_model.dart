class RaceModel {
  final String round;
  final String raceName;
  final String circuitId;
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
    required this.locality,
    required this.country,
    required this.date,
    required this.dateRange,
    required this.isCompleted,
    this.podium,
  });
}

class PodiumDriver {
  final String code; // VER, LEC, ANT
  final String teamName;

  const PodiumDriver({required this.code, required this.teamName});
}