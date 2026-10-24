class DriverModel {
  final String id;
  final String name;
  final int permanentNumber;
  final String teamName;
  final int points;
  final String teammateId; // ID связанной сущности
  final String imageUrl;

  const DriverModel({
    required this.id,
    required this.name,
    required this.permanentNumber,
    required this.teamName,
    required this.points,
    required this.teammateId,
    required this.imageUrl,
  });
}