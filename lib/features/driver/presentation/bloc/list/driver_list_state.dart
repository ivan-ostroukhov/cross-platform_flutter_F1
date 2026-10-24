import '../../../domain/driver_model.dart';

sealed class DriverListState {
  const DriverListState();
}

final class DriverListLoading extends DriverListState {
  const DriverListLoading();
}

final class DriverListLoaded extends DriverListState {
  final List<DriverModel> drivers;
  final String query;
  const DriverListLoaded({required this.drivers, this.query = ''});
}

final class DriverListNotFound extends DriverListState {
  final String query;
  const DriverListNotFound(this.query);
}