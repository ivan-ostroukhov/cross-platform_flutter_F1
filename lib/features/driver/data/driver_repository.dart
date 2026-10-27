import '../domain/driver_model.dart';
import '../domain/i_driver_repository.dart';
import 'dto/driver_dto.dart';
import 'data_sources/driver_data_source.dart';
import 'mappers/driver_mapper.dart';
import '../../../../common/network/load_exception.dart';

class DriverRepository implements IDriverRepository {
  final IDriverDataSource _dataSource;

  const DriverRepository(this._dataSource);

  @override
  Future<List<DriverModel>> getDrivers({String? query}) async {
    final dtos = await _dataSource.getDriverStandings();
    final drivers = dtos.toDomainList();

    if (query == null || query.trim().isEmpty) {
      return drivers;
    }
    final q = query.trim().toLowerCase();
    return drivers
        .where((d) =>
    d.name.toLowerCase().contains(q) ||
        d.teamName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<DriverModel?> getDriverById(String id) async {
    final results = await Future.wait([
      _dataSource.getDriverStandings(),
      _dataSource
          .getDriverById(id)
          .then<DriverStandingDto?>((val) => val)
          .catchError((_) => null),
    ]);

    final standings = results[0] as List<DriverStandingDto>;
    final specificDto = results[1] as DriverStandingDto?;

    final domainList = standings.toDomainList();
    final fromList = domainList
        .where((d) => d.id == id)
        .firstOrNull;

    if (fromList != null) {
      return fromList;
    }

    if (specificDto != null) {
      return specificDto.toDomain(teammateId: id);
    }

    throw const NotFoundLoadException();
  }
}