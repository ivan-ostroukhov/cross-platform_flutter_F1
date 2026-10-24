// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Формула 1';

  @override
  String get searchPlaceholder => 'Поиск пилота или команды...';

  @override
  String get points => 'Очков';

  @override
  String get teammate => 'Напарник';

  @override
  String get viewTeammate => 'Перейти к напарнику';

  @override
  String get notFoundTitle => 'Пилоты не найдены';

  @override
  String get notFoundSubtitle => 'Попробуйте изменить запрос';

  @override
  String get errorLoading => 'Ошибка загрузки данных из сети';

  @override
  String get retry => 'Повторить';
}
