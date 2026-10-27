class CircuitStats {
  final String lengthKm;
  final int laps;
  final int corners;
  final String maxSpeed;
  final String elevation;

  const CircuitStats({
    required this.lengthKm,
    required this.laps,
    required this.corners,
    required this.maxSpeed,
    required this.elevation,
  });

  static const CircuitStats _defaultStats = CircuitStats(
    lengthKm: '5.338',
    laps: 56,
    corners: 16,
    maxSpeed: '335.0',
    elevation: '25.0',
  );

  static const Map<String, CircuitStats> byId = {
    'bahrain': CircuitStats(lengthKm: '5.412', laps: 57, corners: 15, maxSpeed: '338.0', elevation: '14.0'),
    'jeddah': CircuitStats(lengthKm: '6.174', laps: 50, corners: 27, maxSpeed: '350.0', elevation: '4.2'),
    'albert_park': CircuitStats(lengthKm: '5.278', laps: 58, corners: 14, maxSpeed: '342.0', elevation: '2.6'),
    'suzuka': CircuitStats(lengthKm: '5.807', laps: 53, corners: 18, maxSpeed: '332.0', elevation: '40.4'),
    'shanghai': CircuitStats(lengthKm: '5.451', laps: 56, corners: 16, maxSpeed: '340.0', elevation: '7.4'),
    'miami': CircuitStats(lengthKm: '5.412', laps: 57, corners: 19, maxSpeed: '348.0', elevation: '9.0'),
    'imola': CircuitStats(lengthKm: '4.909', laps: 63, corners: 19, maxSpeed: '334.0', elevation: '29.6'),
    'monaco': CircuitStats(lengthKm: '3.337', laps: 78, corners: 19, maxSpeed: '290.0', elevation: '42.0'),
    'villeneuve': CircuitStats(lengthKm: '4.361', laps: 70, corners: 14, maxSpeed: '346.0', elevation: '5.2'),
    'catalunya': CircuitStats(lengthKm: '4.657', laps: 66, corners: 14, maxSpeed: '341.0', elevation: '29.0'),
    'red_bull_ring': CircuitStats(lengthKm: '4.318', laps: 71, corners: 10, maxSpeed: '338.0', elevation: '63.5'),
    'silverstone': CircuitStats(lengthKm: '5.891', laps: 52, corners: 18, maxSpeed: '344.0', elevation: '11.3'),
    'hungaroring': CircuitStats(lengthKm: '4.381', laps: 70, corners: 14, maxSpeed: '325.0', elevation: '34.7'),
    'spa': CircuitStats(lengthKm: '7.004', laps: 44, corners: 19, maxSpeed: '353.0', elevation: '102.2'),
    'zandvoort': CircuitStats(lengthKm: '4.259', laps: 72, corners: 14, maxSpeed: '325.0', elevation: '8.9'),
    'monza': CircuitStats(lengthKm: '5.793', laps: 53, corners: 11, maxSpeed: '360.0', elevation: '12.8'),
    'baku': CircuitStats(lengthKm: '6.003', laps: 51, corners: 20, maxSpeed: '355.0', elevation: '24.0'),
    'marina_bay': CircuitStats(lengthKm: '4.940', laps: 62, corners: 19, maxSpeed: '320.0', elevation: '5.3'),
    'americas': CircuitStats(lengthKm: '5.513', laps: 56, corners: 20, maxSpeed: '342.0', elevation: '40.9'),
    'rodriguez': CircuitStats(lengthKm: '4.304', laps: 71, corners: 17, maxSpeed: '355.0', elevation: '2.8'),
    'interlagos': CircuitStats(lengthKm: '4.309', laps: 71, corners: 15, maxSpeed: '338.3', elevation: '42.98'),
    'vegas': CircuitStats(lengthKm: '6.201', laps: 50, corners: 17, maxSpeed: '350.0', elevation: '4.0'),
    'losail': CircuitStats(lengthKm: '5.419', laps: 57, corners: 16, maxSpeed: '345.0', elevation: '1.5'),
    'yas_marina': CircuitStats(lengthKm: '5.281', laps: 58, corners: 16, maxSpeed: '335.0', elevation: '10.7'),
  };

  static CircuitStats getFor(String circuitId) {
    return byId[circuitId] ?? _defaultStats;
  }
}