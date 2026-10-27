import 'driver_model.dart';
import 'driver_detail_model.dart';

abstract interface class IDriverRepository {
  Future<List<DriverModel>> getDrivers({String? query});
  Future<DriverModel?> getDriverById(String id);
  Future<DriverDetailModel> getDriverDetails(String driverId);
}