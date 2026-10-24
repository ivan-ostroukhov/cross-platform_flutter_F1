import 'driver_model.dart';

abstract interface class IDriverRepository {
  Future<List<DriverModel>> getDrivers({String? query});
  Future<DriverModel?> getDriverById(String id);
}