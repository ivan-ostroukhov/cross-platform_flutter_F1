import 'package:dio/dio.dart';
import '../../../../common/network/load_exception.dart';
import '../dto/constructor_dto.dart';
import 'constructor_data_source.dart';

class ConstructorRemoteDataSource implements IConstructorDataSource {
  final Dio _dio;

  const ConstructorRemoteDataSource(this._dio);

  @override
  Future<List<ConstructorStandingDto>> getConstructorStandings({String? season}) async {
    try {
      final s = season ?? 'current';
      final response = await _dio.get('/$s/constructorStandings.json');
      if (response.data == null) {
        throw const NetworkLoadException();
      }
      final dto = ErgastConstructorResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return dto.standings;
    } on DioException {
      throw const NetworkLoadException();
    } catch (_) {
      throw const NetworkLoadException();
    }
  }
}