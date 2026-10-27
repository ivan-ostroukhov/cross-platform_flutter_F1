import 'package:flutter/material.dart';

class F1Colors {
  static const List<Color> circuitPalette = [
    Color(0xFF0F5A28), // зеленый (São Paulo / Brazil)
    Color(0xFF15448C), // синий (Las Vegas / USA)
    Color(0xFF7A1828), // бордовый (Qatar)
    Color(0xFF0E7A6B), // бирюзовый (Abu Dhabi)
    Color(0xFFB55A12), // терракотовый
    Color(0xFF5B2382), // фиолетовый
    Color(0xFF1E3D59), // глубокий индиго
    Color(0xFF8B263E), // рубиновый
  ];

  static Color getCircuitColor(String key) {
    if (key.isEmpty) return circuitPalette.first;
    final hash = key.codeUnits.fold<int>(0, (acc, val) => acc + val);
    return circuitPalette[hash % circuitPalette.length];
  }

  static Color getTeamColor(String teamName) {
    final lower = teamName.toLowerCase();
    if (lower.contains('red bull')) return const Color(0xFF3671C6);
    if (lower.contains('ferrari')) return const Color(0xFFE80020);
    if (lower.contains('mercedes')) return const Color(0xFF27F4D2);
    if (lower.contains('mclaren')) return const Color(0xFFFF8000);
    if (lower.contains('aston')) return const Color(0xFF229971);
    if (lower.contains('alpine')) return const Color(0xFFFF87BC);
    if (lower.contains('williams')) return const Color(0xFF64C4FF);
    if (lower.contains('haas')) return const Color(0xFFB6BABD);
    if (lower.contains('rb') || lower.contains('racing bulls')) return const Color(0xFF6692FF);
    if (lower.contains('sauber') || lower.contains('kick')) return const Color(0xFF52E252);
    return Colors.white54;
  }
}