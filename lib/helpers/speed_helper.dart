import 'dart:math';
import 'package:flutter/material.dart';

abstract class SpeedHelper {
  static DateTime? _startTimeStamps;
  static double _startSpeed = 0.0;
  static const double limiarBalanco = 0.5;
  static const double limiarConstancia =
      0.1; // Limiar para detectar acelerações constantes
  static const double limiarFrequencia =
      0.3; // Limiar para detecção de flutuações rápidas

  static List<double> _lastAccelerations =
      []; // Lista para armazenar as últimas acelerações para filtragem

  static dynamic calcSpeed({
    required double z,
    required DateTime timestamp,
    required double x,
    required double y,
  }) {
    const double g = 9.81;
    _startTimeStamps ??= DateTime.now();

    dynamic deltaTime = timestamp.difference(_startTimeStamps!).inMilliseconds /
        1000.0; // em segundos
    debugPrint("Delta Time: $deltaTime");

    double accelerometer = sqrt(x * x + y * y + z * z) - g;

    debugPrint("Aceleração: $accelerometer");

    if (accelerometer.abs() < limiarBalanco) {
      debugPrint("Movimento ignorado (balanço).");
      return 0.0;
    }

    // Aplicar um filtro de baixa frequência para suavizar acelerações instáveis
    double filteredAccel = LowPassFilter.apply(accelerometer);

    // Adiciona a aceleração filtrada à lista
    _lastAccelerations.add(filteredAccel);

    // Limita o número de acelerações armazenadas (mantendo as últimas 10)
    if (_lastAccelerations.length > 10) {
      _lastAccelerations.removeAt(0);
    }

    // Verificar se as acelerações variam muito (indicativo de movimento de mão)
    if (_isHighFrequencyMovement()) {
      debugPrint(
          "Movimento detectado como de alta frequência (balanço de mão).");
      return 0.0;
    }

    // Verificar se a aceleração é constante
    if (_isConstantMovement()) {
      debugPrint("Movimento considerado constante.");
      return _startSpeed; // Retornar a velocidade anterior, como movimento constante
    }

    if (deltaTime > 0) {
      double lastSpeed = _startSpeed + (filteredAccel * deltaTime);
      _startSpeed = lastSpeed; // Atualizar a velocidade de referência

      _startTimeStamps = timestamp;

      return _formatLastSpeed(speed: lastSpeed);
    }

    return null;
  }

  static bool _isHighFrequencyMovement() {
    // Verifica se a variação entre as acelerações é muito alta (indicativo de movimento de alta frequência)
    if (_lastAccelerations.length < 2) return false;

    double maxChange = 0.0;
    for (int i = 1; i < _lastAccelerations.length; i++) {
      double change = (_lastAccelerations[i] - _lastAccelerations[i - 1]).abs();
      if (change > maxChange) maxChange = change;
    }

    return maxChange > limiarFrequencia;
  }

  static bool _isConstantMovement() {
    // Verifica se as acelerações são constantes (com pouca variação)
    if (_lastAccelerations.length < 2) return false;

    double avgAccel =
        _lastAccelerations.reduce((a, b) => a + b) / _lastAccelerations.length;
    double totalDiff = 0.0;

    for (var accel in _lastAccelerations) {
      totalDiff += (accel - avgAccel).abs();
    }

    double averageDiff = totalDiff / _lastAccelerations.length;
    return averageDiff < limiarConstancia;
  }

  static dynamic _formatLastSpeed({required double speed}) {
    return double.parse(
        (speed * 3.6).toStringAsFixed(0)); // Converter m/s para km/h
  }
}

abstract class LowPassFilter {
  static double _previousValue = 0.0;

  static double apply(double currentValue) {
    // Filtro de baixa frequência para suavizar flutuações pequenas na aceleração
    _previousValue = 0.1 * currentValue + 0.9 * _previousValue;
    return _previousValue;
  }
}
