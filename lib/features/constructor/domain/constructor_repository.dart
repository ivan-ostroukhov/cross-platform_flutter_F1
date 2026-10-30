import 'constructor_model.dart';

abstract interface class IConstructorRepository {
  Future<List<ConstructorModel>> getConstructors({String? query, String season = '2026'});
}