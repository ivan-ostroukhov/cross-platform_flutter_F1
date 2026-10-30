import 'constructor_model.dart';
import 'constructor_detail_model.dart';

abstract interface class IConstructorRepository {
  Future<List<ConstructorModel>> getConstructors({String? query, String? season});
  Future<ConstructorDetailModel> getConstructorDetails(String constructorId, {String? season});
  Future<List<String>> getConstructorSeasons(String constructorId);
}