import 'package:flutter/material.dart';

class F1Colors {
  const F1Colors._();

  static Color getTeamColor(String? teamName) {
    if (teamName == null) return Colors.grey;
    final name = teamName.toLowerCase();

    if (name.contains('mercedes')) {
      return const Color(0xFF27F4D2);
    } else if (name.contains('ferrari')) {
      return const Color(0xFFE80020);
    } else if (name.contains('red bull') || name.contains('redbull')) {
      return const Color(0xFF3671C6);
    } else if (name.contains('mclaren')) {
      return const Color(0xFFFF8000);
    } else if (name.contains('aston martin')) {
      return const Color(0xFF229971);
    } else if (name.contains('alpine')) {
      return const Color(0xFFFF87BC);
    } else if (name.contains('williams')) {
      return const Color(0xFF64C4FF);
    } else if (name.contains('rb') || name.contains('racing bulls')) {
      return const Color(0xFF6692FF);
    } else if (name.contains('sauber') || name.contains('kick')) {
      return const Color(0xFF52E252);
    } else if (name.contains('haas')) {
      return const Color(0xFFB6BABD);
    }
    return Colors.white70;
  }
}