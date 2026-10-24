import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/i_driver_repository.dart';
import 'driver_list_state.dart';

class DriverListCubit extends Cubit<DriverListState> {
  final IDriverRepository _repository;

  DriverListCubit(this._repository) : super(const DriverListLoading());

  Future<void> loadDrivers() async {
    emit(const DriverListLoading());
    final drivers = await _repository.getDrivers();
    emit(DriverListLoaded(drivers: drivers));
  }

  Future<void> search(String query) async {
    emit(const DriverListLoading());
    final result = await _repository.getDrivers(query: query);
    if (result.isEmpty) {
      emit(DriverListNotFound(query));
    } else {
      emit(DriverListLoaded(drivers: result, query: query));
    }
  }
}