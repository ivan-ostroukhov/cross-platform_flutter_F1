import '../../domain/race_model.dart';
import '../dto/race_dto.dart';

extension RaceDtoMapper on RaceDto {
  RaceModel toDomain() {
    DateTime parsedDate;
    try {
      final dateTimeString = time != null ? '${date}T$time' : date;
      parsedDate = DateTime.parse(dateTimeString).toLocal();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return RaceModel(
      round: int.tryParse(round) ?? 0,
      raceName: raceName,
      circuitName: circuit.circuitName,
      locality: circuit.location.locality,
      country: circuit.location.country,
      raceDateTime: parsedDate,
    );
  }
}

extension RaceDtoListMapper on List<RaceDto> {
  List<RaceModel> toDomainList() {
    return map((dto) => dto.toDomain()).toList();
  }
}