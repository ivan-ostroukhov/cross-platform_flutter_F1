class ErgastRaceResponseDto {
  final List<RaceDto> races;

  const ErgastRaceResponseDto({required this.races});

  factory ErgastRaceResponseDto.fromJson(Map<String, dynamic> json) {
    final mrData = json['MRData'] as Map<String, dynamic>? ?? {};
    final raceTable = mrData['RaceTable'] as Map<String, dynamic>? ?? {};
    final racesList = raceTable['Races'] as List<dynamic>? ?? [];

    return ErgastRaceResponseDto(
      races: racesList
          .map((e) => RaceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RaceDto {
  final String round;
  final String raceName;
  final CircuitDto circuit;
  final String date;
  final String? time;

  const RaceDto({
    required this.round,
    required this.raceName,
    required this.circuit,
    required this.date,
    this.time,
  });

  factory RaceDto.fromJson(Map<String, dynamic> json) {
    return RaceDto(
      round: json['round'] as String? ?? '0',
      raceName: json['raceName'] as String? ?? '',
      circuit: CircuitDto.fromJson(json['Circuit'] as Map<String, dynamic>? ?? {}),
      date: json['date'] as String? ?? '',
      time: json['time'] as String?,
    );
  }
}

class CircuitDto {
  final String circuitName;
  final LocationDto location;

  const CircuitDto({
    required this.circuitName,
    required this.location,
  });

  factory CircuitDto.fromJson(Map<String, dynamic> json) {
    return CircuitDto(
      circuitName: json['circuitName'] as String? ?? '',
      location: LocationDto.fromJson(json['Location'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class LocationDto {
  final String locality;
  final String country;

  const LocationDto({
    required this.locality,
    required this.country,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      locality: json['locality'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }
}