import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensor/helpers/g_force_helper.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Duration sensorInterval = SensorInterval.uiInterval;

  String? _gForce;
  LocationPermission? permissionGranted;
  Position? locationPosition;

  String checkSpeed() {
    if (locationPosition != null) {
      return locationPosition!.speed.toStringAsFixed(0);
    }

    return '0';
  }

  locationRequestService() async {
    bool serviceEnabled;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    } catch (e) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.red,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(e.toString()),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  locationPermission() async {
    LocationPermission? permission;

    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      listenLocation();

      setState(() {
        permissionGranted = permission;
      });
    } catch (e) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.red,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(e.toString()),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  listenLocation() {
    LocationSettings locationSettings = AndroidSettings(
      intervalDuration: const Duration(milliseconds: 1),
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
      forceLocationManager: true,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        setState(() {
          locationPosition = position;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    locationPermission();
    locationRequestService();
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen((event) {
        String gF = GForceHelper.getGForce(
          z: event.z,
          x: event.x,
          y: event.y,
        ).toStringAsFixed(1);

        setState(() {
          _gForce = gF;
        });
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text(
            'G Force',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.speed,
                      color: Colors.black,
                      size: 80,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${locationPosition != null ? (locationPosition!.speed * 3.6).toStringAsFixed(0) : 0}',
                      style: const TextStyle(
                        fontSize: 80,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Text(
                        'km/h',
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'G Force: ${_gForce ?? 0}G',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'Accuracy: ${locationPosition != null ? (locationPosition!.speedAccuracy * 3.6).toStringAsFixed(0) : 0}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'Speed: ${locationPosition != null ? (locationPosition!.speed * 3.6).toStringAsFixed(0) : 0}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  'Permission: ${permissionGranted?.name ?? 'ERROR'}',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
