import '../../../../common/theme/image_sources.dart';
import '../../domain/driver_model.dart';
import '../dto/driver_dto.dart';

extension DriverStandingDtoMapper on DriverStandingDto {
  DriverModel toDomain({required String teammateId}) {
    final team = constructors.isNotEmpty ? constructors.first.name : 'Unknown Team';
    return DriverModel(
      id: driver.driverId,
      name: '${driver.givenName} ${driver.familyName}',
      permanentNumber: int.tryParse(driver.permanentNumber ?? '') ?? 0,
      teamName: team,
      points: double.tryParse(points)?.round() ?? 0,
      teammateId: teammateId,
      imageUrl: ImageSources.driverPlaceholder,
    );
  }
}

extension DriverStandingListMapper on List<DriverStandingDto> {
  List<DriverModel> toDomainList() {
    return map((dto) {
      final teamId = dto.constructors.isNotEmpty ? dto.constructors.first.constructorId : '';

      final teammate = where((other) =>
      other.driver.driverId != dto.driver.driverId &&
          other.constructors.isNotEmpty &&
          other.constructors.first.constructorId == teamId).firstOrNull;

      return dto.toDomain(
        teammateId: teammate?.driver.driverId ?? dto.driver.driverId,
      );
    }).toList();
  }
}