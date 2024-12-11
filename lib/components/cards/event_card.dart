import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    required this.eventInfo,
  });

  final String title;
  final EventInfo eventInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              '$title',
              style: const TextStyle(
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
                      'X',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      eventInfo.x,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Y',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      eventInfo.y,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Z',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      eventInfo.z,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                eventInfo.dateTime != null
                    ? Column(
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
                            DateFormat('dd/MM/yyyy HH:MM:ss').format(
                              DateTime.parse(
                                eventInfo.dateTime!,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EventInfo {
  EventInfo({
    this.x = '0',
    this.y = '0',
    this.z = '0',
    this.dateTime,
  });

  String x;
  String y;
  String z;
  String? dateTime;
}
