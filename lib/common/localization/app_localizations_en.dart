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
}
