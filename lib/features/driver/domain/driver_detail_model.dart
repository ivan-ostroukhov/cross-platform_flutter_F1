class DriverDetailModel {
  final String id;
  final String firstName;
  final String lastName;
  final String code;
  final String permanentNumber;
  final String teamName;
  final String position;
  final String points;
  final int wins;
  final int podiums;
  final int poles;
  final int dnfs;
  final String dateOfBirth;
  final String nationality;
  final String firstRace;
  final String firstWin;
  final int worldChampionships;
  final List<int?> roundPoints;
  final String season;

  const DriverDetailModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.code,
    required this.permanentNumber,
    required this.teamName,
    required this.position,
    required this.points,
    required this.wins,
    required this.podiums,
    required this.poles,
    required this.dnfs,
    required this.dateOfBirth,
    required this.nationality,
    required this.firstRace,
    required this.firstWin,
    required this.worldChampionships,
    required this.roundPoints,
    this.season = '2026',
  });
}