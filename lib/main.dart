import 'dart:async';
import 'dart:math';

/*import 'package:flutter/material.dart';*/
/*import 'package:flutter_blue/flutter_blue.dart';*/
import 'package:flutter/material.dart';
import 'package:polar/polar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const identifier = '20341925';

  late final Polar polar;
  List<String> logs = ['Service started'];

  @override
  void initState() {
    super.initState();

    polar = Polar();
    polar.heartRateStream.listen((e) => log('Heart rate: ${e.data.hr}'));
    polar.streamingFeaturesReadyStream.listen((e) {
      if (e.features.contains(DeviceStreamingFeature.ecg)) {
        polar
            .startEcgStreaming(e.identifier)
            .listen((e) => log('ECG data: ${e.samples}'));
      }
    });
    polar.deviceConnectingStream.listen((_) => log('Device connecting'));
    polar.deviceConnectedStream.listen((_) => log('Device connected'));
    polar.deviceDisconnectedStream.listen((_) => log('Device disconnected'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Polar App'),
            actions: [
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  log('Disconnecting from device: $identifier');
                  polar.disconnectFromDevice(identifier);
                },
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  log('Connecting to device: $identifier');
                  polar.connectToDevice(identifier);
                },
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            children: logs.reversed.map((e) => Text(e)).toList(),
          )),
      /*body: Scaffold(
            body: SfCartesianChart(),
          )),*/
    );
  }

  void log(String log) {
    print(log);
    setState(() {
      logs.add(log);
    });
  }
}
