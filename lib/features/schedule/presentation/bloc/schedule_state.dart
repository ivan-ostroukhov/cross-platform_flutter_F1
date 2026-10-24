import '../../domain/race_model.dart';

sealed class ScheduleState {
  const ScheduleState();
}

final class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

final class ScheduleLoaded extends ScheduleState {
  final List<RaceModel> races;

  const ScheduleLoaded(this.races);
}

final class ScheduleError extends ScheduleState {
  const ScheduleError();
}