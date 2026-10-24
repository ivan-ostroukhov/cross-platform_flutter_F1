class ErgastConstructorResponseDto {
  final List<ConstructorStandingDto> standings;

  const ErgastConstructorResponseDto({required this.standings});

  factory ErgastConstructorResponseDto.fromJson(Map<String, dynamic> json) {
    final mrData = json['MRData'] as Map<String, dynamic>? ?? {};
    final table = mrData['StandingsTable'] as Map<String, dynamic>? ?? {};
    final lists = table['StandingsLists'] as List<dynamic>? ?? [];

    if (lists.isEmpty) {
      return const ErgastConstructorResponseDto(standings: []);
    }

    final constructorStandings =
        lists.first['ConstructorStandings'] as List<dynamic>? ?? [];

    return ErgastConstructorResponseDto(
      standings: constructorStandings
          .map((e) =>
          ConstructorStandingDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ConstructorStandingDto {
  final String position;
  final String points;
  final String wins;
  final ConstructorInfoDto constructor;

  const ConstructorStandingDto({
    required this.position,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  factory ConstructorStandingDto.fromJson(Map<String, dynamic> json) {
    return ConstructorStandingDto(
      position: json['position'] as String? ?? '0',
      points: json['points'] as String? ?? '0',
      wins: json['wins'] as String? ?? '0',
      constructor: ConstructorInfoDto.fromJson(
        json['Constructor'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ConstructorInfoDto {
  final String constructorId;
  final String name;
  final String nationality;

  const ConstructorInfoDto({
    required this.constructorId,
    required this.name,
    required this.nationality,
  });

  factory ConstructorInfoDto.fromJson(Map<String, dynamic> json) {
    return ConstructorInfoDto(
      constructorId: json['constructorId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
    );
  }
}