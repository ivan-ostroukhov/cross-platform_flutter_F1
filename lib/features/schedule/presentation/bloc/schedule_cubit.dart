import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/network/load_exception.dart';
import '../../domain/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final IScheduleRepository _repository;

  ScheduleCubit(this._repository) : super(const ScheduleLoading());

  Future<void> loadSchedule() async {
    emit(const ScheduleLoading());
    try {
      final races = await _repository.getSeasonSchedule();
      emit(ScheduleLoaded(races));
    } on LoadException {
      emit(const ScheduleError());
    } catch (_) {
      emit(const ScheduleError());
    }
  }
}