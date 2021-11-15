/*import 'dart:async';*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polar/polar.dart';
import 'package:flutter_plot/flutter_plot.dart';

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

//Parte del plot
  final List<Point> data = [
    /*const Point(21.0, 19.0),
    const Point(3.0, 7.0),
    const Point(8.0, 9.0),
    const Point(11.0, 14.0),
    const Point(18.0, 17.0),
    const Point(7.0, 8.0),
    const Point(-4.0, -4.0),
    const Point(6.0, 12.0),*/
    const Point(0, 0)
  ];

  @override
  void initState() {
    super.initState();
    var time = 0;
    polar = Polar();
    //log(polar);
    polar.heartRateStream.listen((e) => {
          //log('Heart rate: ${e.data.hr}');
          setState(() {
            data.insert(data.length, Point(time, e.data.hr));
            time++;
          })
        });
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
          title: const Text('Polar App - F.Bondi'),
          actions: [
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                log('Disconnecting from device: $identifier');
                polar.disconnectFromDevice(identifier);
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                log('Connecting to device: $identifier');
                polar.connectToDevice(identifier);
              },
            ),
          ],
        ),
        /*body: ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            children: logs.reversed.map((e) => Text(e)).toList(),
          )),*/
        body: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: const Text('Heart Rate Plot (no trace)'),
                  ),
                  Container(
                    child: Plot(
                      height: 200.0,
                      data: data,
                      gridSize: Offset(5.0, 10.0),
                      style: PlotStyle(
                        pointRadius: 3.0,
                        outlineRadius: 1.0,
                        primary: Colors.white,
                        secondary: Colors.orange,
                        textStyle: const TextStyle(
                          fontSize: 8.0,
                          color: Colors.blueGrey,
                        ),
                        axis: Colors.blueGrey[600],
                        gridline: Colors.blueGrey[100],
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),
                      xTitle: 'Time (seconds)',
                      yTitle: 'BPM',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: const Text(
                        'Heart Rate Plot (with trace and coordinates)'),
                  ),
                  Container(
                    child: Plot(
                      height: 200.0,
                      data: data,
                      gridSize: Offset(5.0, 10.0),
                      style: PlotStyle(
                        axisStrokeWidth: 2.0,
                        pointRadius: 3.0,
                        outlineRadius: 1.0,
                        primary: Colors.yellow,
                        secondary: Colors.red,
                        trace: true,
                        traceStokeWidth: 3.0,
                        traceColor: Colors.blueGrey,
                        traceClose: false,
                        showCoordinates: true,
                        textStyle: const TextStyle(
                          fontSize: 8.0,
                          color: Colors.grey,
                        ),
                        axis: Colors.blueGrey[600],
                        gridline: Colors.blueGrey[100],
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),
                      xTitle: 'Time (seconds)',
                      yTitle: 'BPM',
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Log',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, height: 3),
              textAlign: TextAlign.center,
            ),
            ListView(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              children: logs.reversed.map((e) => Text(e)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void log(String log) {
    print(log);
    setState(() {
      logs.add(log);
    });
  }
}
