import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru'));

  void toggleLocale() {
    emit(state.languageCode == 'ru' ? const Locale('en') : const Locale('ru'));
  }
}