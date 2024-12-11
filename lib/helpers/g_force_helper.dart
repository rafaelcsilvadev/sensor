import 'dart:math';

abstract class GForceHelper {
  static double getGForce({
    required double z,
    required double x,
    required double y,
  }) {
    const double g = 9.81;

    double gz = sqrt(x * x + y * y + z * z) / g;

    return (gz - 1).abs();
  }
}
