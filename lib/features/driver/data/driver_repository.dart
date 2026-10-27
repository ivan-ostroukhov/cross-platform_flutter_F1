import '../domain/driver_model.dart';
import '../domain/i_driver_repository.dart';
import '../domain/driver_detail_model.dart';
import 'dto/driver_dto.dart';
import 'data_sources/driver_data_source.dart';
import 'mappers/driver_mapper.dart';
import '../../../../common/network/load_exception.dart';

class DriverRepository implements IDriverRepository {
  final IDriverDataSource _dataSource;

  const DriverRepository(this._dataSource);

  @override
  Future<List<DriverModel>> getDrivers({String? query}) async {
    final dtos = await _dataSource.getDriverStandings();
    final drivers = dtos.toDomainList();

    if (query == null || query.trim().isEmpty) {
      return drivers;
    }
    final q = query.trim().toLowerCase();
    return drivers
        .where((d) =>
    d.name.toLowerCase().contains(q) ||
        d.teamName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Future<DriverModel?> getDriverById(String id) async {
    final results = await Future.wait([
      _dataSource.getDriverStandings(),
      _dataSource
          .getDriverById(id)
          .then<DriverStandingDto?>((val) => val)
          .catchError((_) => null),
    ]);

    final standings = results[0] as List<DriverStandingDto>;
    final specificDto = results[1] as DriverStandingDto?;

    final domainList = standings.toDomainList();
    final fromList = domainList.where((d) => d.id == id).firstOrNull;

    if (fromList != null) {
      return fromList;
    }

    if (specificDto != null) {
      return specificDto.toDomain(teammateId: id);
    }

    throw const NotFoundLoadException();
  }

  @override
  Future<DriverDetailModel> getDriverDetails(String driverId) async {
    try {
      final seasonData = await _dataSource.getDriverSeasonResults(driverId);
      final careerData = await _dataSource.getDriverCareerMilestones(driverId);

      final raceList =
          seasonData['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];

      int wins = 0;
      int podiums = 0;
      int poles = 0;
      int dnfs = 0;
      final List<int?> roundPoints = [];

      String code = '';
      String permanentNumber = '';
      String dateOfBirth = '';
      String nationality = '';
      String givenName = '';
      String familyName = '';

      for (final race in raceList) {
        final results = race['Results'] as List<dynamic>? ?? [];
        if (results.isEmpty) continue;
        final res = results.first as Map<String, dynamic>;

        final driverObj = res['Driver'] as Map<String, dynamic>? ?? {};
        code = driverObj['code'] as String? ?? code;
        permanentNumber =
            driverObj['permanentNumber'] as String? ?? permanentNumber;
        dateOfBirth = driverObj['dateOfBirth'] as String? ?? dateOfBirth;
        nationality = driverObj['nationality'] as String? ?? nationality;
        givenName = driverObj['givenName'] as String? ?? givenName;
        familyName = driverObj['familyName'] as String? ?? familyName;

        final pos = int.tryParse(res['position'] as String? ?? '') ?? 0;
        final grid = int.tryParse(res['grid'] as String? ?? '') ?? 0;
        final pts = (double.tryParse(res['points'] as String? ?? '') ?? 0).round();
        final status = res['status'] as String? ?? '';

        roundPoints.add(pts);

        if (pos == 1) wins++;
        if (pos >= 1 && pos <= 3) podiums++;
        if (grid == 1) poles++;
        if (!status.toLowerCase().contains('finished') && !status.startsWith('+')) {
          dnfs++;
        }
      }

      final firstRaceList =
          careerData['firstRace']?['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];
      final firstRaceStr = firstRaceList.isNotEmpty
          ? '${firstRaceList.first['season']} ${firstRaceList.first['raceName']}'
          : '—';

      final firstWinList =
          careerData['firstWin']?['MRData']?['RaceTable']?['Races'] as List<dynamic>? ?? [];
      final firstWinStr = firstWinList.isNotEmpty
          ? '${firstWinList.first['season']} ${firstWinList.first['raceName']}'
          : '—';

      final championships = int.tryParse(
        careerData['championships']?['MRData']?['total'] as String? ?? '0',
      ) ?? 0;

      String formattedDob = dateOfBirth;
      if (dateOfBirth.contains('-')) {
        final parts = dateOfBirth.split('-');
        if (parts.length == 3) {
          final year = int.tryParse(parts[0]) ?? 2000;
          final age = DateTime.now().year - year;
          formattedDob = '${parts[2]}.${parts[1]}.${parts[0]} ($age)';
        }
      }

      return DriverDetailModel(
        id: driverId,
        firstName: givenName,
        lastName: familyName,
        code: code.isNotEmpty ? code : (driverId.length >= 3 ? driverId.substring(0, 3).toUpperCase() : driverId.toUpperCase()),
        permanentNumber: permanentNumber,
        teamName: '',
        position: '0',
        points: roundPoints.fold<int>(0, (a, b) => a + (b ?? 0)).toString(),
        wins: wins,
        podiums: podiums,
        poles: poles,
        dnfs: dnfs,
        dateOfBirth: formattedDob.isNotEmpty ? formattedDob : '—',
        nationality: nationality.isNotEmpty ? nationality : '—',
        firstRace: firstRaceStr,
        firstWin: firstWinStr,
        worldChampionships: championships,
        roundPoints: roundPoints,
      );
    } catch (e) {
      return DriverDetailModel(
        id: driverId,
        firstName: '',
        lastName: '',
        code: driverId.length >= 3 ? driverId.substring(0, 3).toUpperCase() : driverId.toUpperCase(),
        permanentNumber: '',
        teamName: '',
        position: '0',
        points: '0',
        wins: 0,
        podiums: 0,
        poles: 0,
        dnfs: 0,
        dateOfBirth: '—',
        nationality: '—',
        firstRace: '—',
        firstWin: '—',
        worldChampionships: 0,
        roundPoints: const [],
      );
    }
  }
}