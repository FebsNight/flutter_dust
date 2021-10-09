import 'package:flutter/material.dart';
import 'package:flutter_dust/models/air_result.dart';

import 'bloc/air_bloc.dart';


void main() {
  runApp(const MyApp());
}

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NearestCity(),
    );
  }
}

class NearestCity extends StatefulWidget {
  const NearestCity({Key? key}) : super(key: key);

  @override
  _NearestCityState createState() => _NearestCityState();
}

class _NearestCityState extends State<NearestCity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AirResult>(
        stream: airBloc.airResult,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildBody(snapshot.data);
          } else {
            return const CircularProgressIndicator();
          }
        }
      ),
    );
  }

  Widget buildBody(AirResult? airResult) {
    num _aqius = airResult!.data!.current!.pollution!.aqius as num;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('현재 위치 미세먼지', style: TextStyle(fontSize: 30)),
            // 위아래 공백
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text('얼굴 사진'),
                        Text('$_aqius', style: const TextStyle(fontSize: 40)),
                        Text(getString(_aqius), style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                    color: getColor(_aqius),
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.network('https://airvisual.com/images/${airResult.data!.current!.weather!.ic}.png', width: 32, height: 32,),
                            const SizedBox(
                              width: 16,
                            ),
                            Text('${airResult.data!.current!.weather!.tp}°', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Text('습도 ${airResult.data!.current!.weather!.hu}%'),
                        Text('풍속 ${airResult.data!.current!.weather!.ws}m/s'),
                      ],
                    ),
                  )
                ]
            ),
            ),
            // 위아래 공백
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                  onPressed: () {
                    // refresh
                    airBloc.fetch();
                  },
                  child: const Icon(Icons.refresh, color: Colors.white) ,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 10.0)
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getColor(num aqius) {
    if (aqius <= 50) {
      return Colors.greenAccent;
    } else if (aqius <= 100) {
      return Colors.yellow;
    } else if (aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(num aqius) {
    if (aqius <= 50) {
      return '좋음';
    } else if (aqius <= 100) {
      return '보통';
    } else if (aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
