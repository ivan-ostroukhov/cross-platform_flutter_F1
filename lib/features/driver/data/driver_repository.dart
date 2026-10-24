import '../domain/driver_model.dart';
import '../domain/i_driver_repository.dart';
import 'data_sources/driver_data_source.dart';
import 'mappers/driver_mapper.dart';

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
      _dataSource.getDriverById(id),
      _dataSource.getDriverStandings(),
    ]);

    final targetDto = results[0] as dynamic;
    final allDtos = results[1] as List<dynamic>;

    final domainList = allDtos.cast<dynamic>().isEmpty
        ? <DriverModel>[]
        : (results[1] as List).cast<dynamic>().toList();

    final mappedAll = (results[1] as dynamic).toDomainList() as List<DriverModel>;
    return mappedAll.where((d) => d.id == id).firstOrNull ??
        (targetDto.toDomain(teammateId: id) as DriverModel);
  }
}