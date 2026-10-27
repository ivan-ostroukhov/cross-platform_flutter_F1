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

  @override
  String get driversTab => 'Пилоты';

  @override
  String get constructorsTab => 'Команды';

  @override
  String get constructorsComingSoon => 'Кубок конструкторов скоро появится';

  @override
  String get scheduleTab => 'Календарь';

  @override
  String get roundPrefix => 'Этап';

  @override
  String get raceCompleted => 'Завершен';

  @override
  String get raceUpcoming => 'Предстоит';

  @override
  String get driverPositionShort => 'поз';

  @override
  String get driverPointsShort => 'блв';

  @override
  String get winsLabel => 'Победы';

  @override
  String get podiumsLabel => 'Подиумы';

  @override
  String get polesLabel => 'Поулы';

  @override
  String get dnfsLabel => 'DNFs';

  @override
  String seasonPrefix(String year) {
    return '$year Сезон';
  }

  @override
  String get driverCodeLabel => 'Код гонщика';

  @override
  String get teamLabel => 'Команда';

  @override
  String get firstRaceLabel => 'Первая гонка';

  @override
  String get firstWinLabel => 'Первая победа';

  @override
  String get worldChampionshipsLabel => 'Мировой чемпионат';

  @override
  String get dateOfBirthLabel => 'Дата рождения';

  @override
  String get countryLabel => 'Страна';

  @override
  String get pastRaces => 'Прошедшие гонки';

  @override
  String get upcomingRaces => 'Предстоящие гонки';

  @override
  String get raceCountdownPrefix => 'Гонка начинается через';

  @override
  String get daysShort => 'Дни';

  @override
  String get hoursShort => 'Часы';

  @override
  String get minutesShort => 'Минуты';

  @override
  String get scheduleButton => 'Расписание';

  @override
  String get resultsButton => 'Результаты';
}
