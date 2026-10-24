import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/i_driver_repository.dart';
import 'driver_detail_state.dart';

class DriverDetailCubit extends Cubit<DriverDetailState> {
  final IDriverRepository _repository;

  DriverDetailCubit(this._repository) : super(const DriverDetailLoading());

  Future<void> load(String id) async {
    emit(const DriverDetailLoading());
    final driver = await _repository.getDriverById(id);
    if (isClosed) return;

    if (driver != null) {
      emit(DriverDetailLoaded(driver));
    } else {
      emit(const DriverDetailNotFound());
    }
  }
}