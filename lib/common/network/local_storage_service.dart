import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _boxName = 'f1_app_box';
  static Box? _box;
  static Map<String, dynamic>? _bundledPodiums;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
    await _loadBundledJson();
    await _seedInitialData();
  }

  static Future<void> _loadBundledJson() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/f1_history.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      _bundledPodiums = data['podiums'] as Map<String, dynamic>? ?? {};
    } catch (_) {}
  }

  static Future<void> _seedInitialData() async {
    if (_box == null || _bundledPodiums == null) return;
    for (final entry in _bundledPodiums!.entries) {
      final key = 'podium_${entry.key}';
      if (!_box!.containsKey(key)) {
        await _box!.put(key, jsonEncode(entry.value));
      }
    }
  }

  static String? getString(String key) {
    final value = _box?.get(key) as String?;
    if (value != null && value.isNotEmpty) {
      return value;
    }
    if (key.startsWith('podium_') && _bundledPodiums != null) {
      final roundNum = key.replaceAll('podium_', '');
      if (_bundledPodiums!.containsKey(roundNum)) {
        final podiumList = _bundledPodiums![roundNum];
        final encoded = jsonEncode(podiumList);
        _box?.put(key, encoded);
        return encoded;
      }
    }
    return null;
  }

  static Future<void> setString(String key, String value) async {
    await _box?.put(key, value);
  }

  static Future<void> clearKey(String key) async {
    await _box?.delete(key);
  }
}