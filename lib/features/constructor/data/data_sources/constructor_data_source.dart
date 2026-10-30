import '../dto/constructor_dto.dart';

abstract interface class IConstructorDataSource {
  Future<List<ConstructorStandingDto>> getConstructorStandings({String? season});
}