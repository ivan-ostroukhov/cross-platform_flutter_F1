import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/network/load_exception.dart';
import '../../domain/constructor_model.dart';
import '../../domain/constructor_repository.dart';
import 'constructor_list_state.dart';

class ConstructorListCubit extends Cubit<ConstructorListState> {
  final IConstructorRepository _repository;
  List<ConstructorModel> _allConstructors = [];
  String _currentSeason = '2026';

  String get currentSeason => _currentSeason;

  ConstructorListCubit(this._repository) : super(const ConstructorListLoading());

  Future<void> loadConstructors({String season = '2026'}) async {
    _currentSeason = season;
    emit(const ConstructorListLoading());
    try {
      _allConstructors = await _repository.getConstructors(season: season);
      emit(ConstructorListLoaded(_allConstructors));
      emit(ConstructorListLoaded(_allConstructors));
    } on LoadException {
      emit(const ConstructorListError());
    } catch (_) {
      emit(const ConstructorListError());
    }
  }

  void search(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      emit(ConstructorListLoaded(_allConstructors));
      return;
    }

    final filtered = _allConstructors
        .where((c) =>
    c.name.toLowerCase().contains(trimmed) ||
        c.nationality.toLowerCase().contains(trimmed))
        .toList();

    if (filtered.isEmpty) {
      emit(ConstructorListNotFound(query));
    } else {
      emit(ConstructorListLoaded(filtered));
    }
  }
}