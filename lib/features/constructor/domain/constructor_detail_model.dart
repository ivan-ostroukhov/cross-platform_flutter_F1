class ConstructorDriverModel {
  final String id;
  final String permanentNumber;
  final String code;
  final String name;

  const ConstructorDriverModel({
    required this.id,
    required this.permanentNumber,
    required this.code,
    required this.name,
  });
}

class ConstructorDetailModel {
  final String id;
  final String name;
  final String chassis;
  final String engine;
  final String teamPrincipal;
  final String firstRace;
  final int constructorsTitles;
  final int driversTitles;
  final String baseLocation;
  final String position;
  final String points;
  final int wins;
  final int podiums;
  final int poles;
  final int dnfs;
  final String season;
  final String carAssetPath;
  final List<ConstructorDriverModel> drivers;

  const ConstructorDetailModel({
    required this.id,
    required this.name,
    required this.chassis,
    required this.engine,
    required this.teamPrincipal,
    required this.firstRace,
    required this.constructorsTitles,
    required this.driversTitles,
    required this.baseLocation,
    required this.position,
    required this.points,
    required this.wins,
    required this.podiums,
    required this.poles,
    required this.dnfs,
    required this.season,
    required this.carAssetPath,
    required this.drivers,
  });
}