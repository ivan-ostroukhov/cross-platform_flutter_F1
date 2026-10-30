import '../dto/constructor_dto.dart';

abstract interface class IConstructorDataSource {
  Future<List<ConstructorStandingDto>> getConstructorStandings({String? season});
  Future<Map<String, dynamic>> getConstructorSeasonResults(String constructorId, {String? season});
  Future<ConstructorStandingDto?> getConstructorStandingForSeason(String constructorId, {String? season});
  Future<Map<String, dynamic>> getConstructorCareerMilestones(String constructorId);
  Future<List<String>> getConstructorSeasons(String constructorId);
}