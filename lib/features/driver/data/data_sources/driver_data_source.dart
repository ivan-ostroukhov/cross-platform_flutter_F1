import '../dto/driver_dto.dart';

abstract interface class IDriverDataSource {
  Future<List<DriverStandingDto>> getDriverStandings({int limit = 30, int offset = 0});
  Future<DriverStandingDto> getDriverById(String id);
}