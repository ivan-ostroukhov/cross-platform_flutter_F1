// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Formula 1 Hub';

  @override
  String get searchPlaceholder => 'Search driver or team...';

  @override
  String get points => 'PTS';

  @override
  String get teammate => 'Teammate';

  @override
  String get viewTeammate => 'View teammate profile';

  @override
  String get notFoundTitle => 'No drivers found';

  @override
  String get notFoundSubtitle => 'Try another query';

  @override
  String get errorLoading => 'Failed to load data from network';

  @override
  String get retry => 'Retry';

  @override
  String get driversTab => 'Drivers';

  @override
  String get constructorsTab => 'Constructors';

  @override
  String get constructorsComingSoon => 'Constructors championship coming soon';

  @override
  String get scheduleTab => 'Schedule';

  @override
  String get roundPrefix => 'Round';

  @override
  String get raceCompleted => 'Finished';

  @override
  String get raceUpcoming => 'Upcoming';

  @override
  String get driverPositionShort => 'pos';

  @override
  String get driverPointsShort => 'pts';

  @override
  String get winsLabel => 'Wins';

  @override
  String get podiumsLabel => 'Podiums';

  @override
  String get polesLabel => 'Poles';

  @override
  String get dnfsLabel => 'DNFs';

  @override
  String seasonPrefix(String year) {
    return 'Season $year';
  }

  @override
  String get selectSeason => 'Select Season';

  @override
  String sinceDebut(String year) {
    return 'Since Debut ($year)';
  }

  @override
  String get driverCodeLabel => 'Driver Code';

  @override
  String get teamLabel => 'Team';

  @override
  String get firstRaceLabel => 'First Entry';

  @override
  String get firstWinLabel => 'First Win';

  @override
  String get worldChampionshipsLabel => 'World Championships';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get countryLabel => 'Country';

  @override
  String get pastRaces => 'Past Races';

  @override
  String get upcomingRaces => 'Upcoming Races';

  @override
  String get raceCountdownPrefix => 'Race starts in';

  @override
  String get daysShort => 'Days';

  @override
  String get hoursShort => 'Hours';

  @override
  String get minutesShort => 'Mins';

  @override
  String get scheduleButton => 'Schedule';

  @override
  String get resultsButton => 'Results';
}
