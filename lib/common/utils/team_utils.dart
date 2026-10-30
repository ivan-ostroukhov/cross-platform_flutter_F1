class TeamUtils {
  static String cleanTeamName(String raw) {
    if (raw.isEmpty) return raw;
    var name = raw;

    name = name.replaceAll(RegExp(r'\s+F1\s+Team.*', caseSensitive: false), '');
    name = name.replaceAll(RegExp(r'\s+Formula\s+One\s+Team.*', caseSensitive: false), '');
    name = name.replaceAll(RegExp(r'\s+Aramco.*', caseSensitive: false), '');
    name = name.replaceAll(RegExp(r'\s+Stake.*', caseSensitive: false), '');
    name = name.trim();

    final lower = name.toLowerCase();
    if (lower == 'rb') return 'Racing Bulls';
    if (lower.contains('red bull')) return 'Red Bull';
    if (lower.contains('ferrari')) return 'Ferrari';
    if (lower.contains('mercedes')) return 'Mercedes';
    if (lower.contains('mclaren')) return 'McLaren';
    if (lower.contains('aston')) return 'Aston Martin';
    if (lower.contains('alpine')) return 'Alpine';
    if (lower.contains('williams')) return 'Williams';
    if (lower.contains('haas')) return 'Haas';
    if (lower.contains('sauber') || lower.contains('kick')) return 'Sauber';

    return name;
  }
}