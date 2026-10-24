class RaceModel {
  final int round;
  final String raceName;
  final String circuitName;
  final String locality;
  final String country;
  final DateTime raceDateTime;

  const RaceModel({
    required this.round,
    required this.raceName,
    required this.circuitName,
    required this.locality,
    required this.country,
    required this.raceDateTime,
  });

  bool get isPast => DateTime.now().isAfter(raceDateTime);
}