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
}
