import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BarometerEventCard extends StatelessWidget {
  const BarometerEventCard({
    super.key,
    required this.title,
    required this.barometerEvent,
  });

  final BarometerEvent barometerEvent;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              'Barômetro:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Pressão',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${barometerEvent.pressure.toStringAsFixed(1)} hPa',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Tempo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy HH:MM:ss')
                          .format(barometerEvent.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
