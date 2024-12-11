abstract class SpeedParserHelper {
  static int msToKmh({
    required double speedAccuracy,
    required double speed,
  }) {
    double spd;

    if (speedAccuracy <= 1.0 && speed > 0 && speed < 50) {
      spd = speed;
    } else {
      spd = speedAccuracy;
    }

    return int.parse((spd * 3.6).toStringAsFixed(0));
  }
}
