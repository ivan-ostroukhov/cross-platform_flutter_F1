import '../domain/constructor_model.dart';
import '../domain/constructor_repository.dart';
import 'data_sources/constructor_data_source.dart';
import 'mappers/constructor_mapper.dart';

class ConstructorRepository implements IConstructorRepository {
  final IConstructorDataSource _dataSource;

  const ConstructorRepository(this._dataSource);

  @override
  Future<List<ConstructorModel>> getConstructors({String? query}) async {
    final standings = await _dataSource.getConstructorStandings();
    final constructors = standings.toDomainList();

    if (query == null || query.trim().isEmpty) {
      return constructors;
    }

    final q = query.trim().toLowerCase();
    return constructors
        .where((c) =>
    c.name.toLowerCase().contains(q) ||
        c.nationality.toLowerCase().contains(q))
        .toList();
  }
}