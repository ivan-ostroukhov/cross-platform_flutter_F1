class F1Media {
  const F1Media._();

  static const Map<String, String> defaultHeaders = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
  };

  // Прямые ссылки на портреты / шлемы
  static String getDriverImageUrl(String driverId) {
    final key = driverId.toLowerCase().replaceAll('-', '_');
    return _driverImages[key] ?? _driverImages[_shortKey(key)] ?? '';
  }

  static String _shortKey(String key) {
    if (key.contains('_')) return key.split('_').last;
    return key;
  }

  static const Map<String, String> _driverImages = {
    'antonelli': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/antonelli.png',
    'andrea_kimi_antonelli': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/antonelli.png',
    'verstappen': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/verstappen.png',
    'norris': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/norris.png',
    'leclerc': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/leclerc.png',
    'russell': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/russell.png',
    'hamilton': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/hamilton.png',
    'piastri': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/piastri.png',
    'sainz': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/sainz.png',
    'alonso': 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/2025Drivers/alonso.png',
  };
}