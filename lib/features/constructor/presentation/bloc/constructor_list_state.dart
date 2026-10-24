import '../../domain/constructor_model.dart';

sealed class ConstructorListState {
  const ConstructorListState();
}

final class ConstructorListLoading extends ConstructorListState {
  const ConstructorListLoading();
}

final class ConstructorListLoaded extends ConstructorListState {
  final List<ConstructorModel> constructors;

  const ConstructorListLoaded(this.constructors);
}

final class ConstructorListNotFound extends ConstructorListState {
  final String query;

  const ConstructorListNotFound(this.query);
}

final class ConstructorListError extends ConstructorListState {
  const ConstructorListError();
}