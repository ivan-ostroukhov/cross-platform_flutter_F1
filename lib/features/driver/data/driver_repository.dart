import '../domain/driver_model.dart';
import '../domain/i_driver_repository.dart';
import 'driver_mock_data.dart';

class DriverRepository implements IDriverRepository {
  @override
  Future<List<DriverModel>> getDrivers({String? query}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query == null || query.trim().isEmpty) {
      return kF1Drivers;
    }
    final q = query.trim().toLowerCase();
    return kF1Drivers
        .where((d) => d.name.toLowerCase().contains(q) || d.teamName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<DriverModel?> getDriverById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return kF1Drivers.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}