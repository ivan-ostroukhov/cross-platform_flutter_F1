import '../../../domain/driver_model.dart';


sealed class DriverDetailState {
  const DriverDetailState();
}

final class DriverDetailLoading extends DriverDetailState {
  const DriverDetailLoading();
}

final class DriverDetailLoaded extends DriverDetailState {
  final DriverModel driver;
  const DriverDetailLoaded(this.driver);
}

final class DriverDetailError extends DriverDetailState {
  const DriverDetailError();
}

final class DriverDetailNotFound extends DriverDetailState {
  const DriverDetailNotFound();
}