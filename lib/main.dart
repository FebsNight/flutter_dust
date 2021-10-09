import 'package:flutter/material.dart';
import 'package:flutter_dust/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

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
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult? _airResult;

  Future<AirResult> fetchData() async {
    var url = Uri.http('api.airvisual.com', '/v2/nearest_city', {'key' : '19858f4f-0b57-4859-8108-55dce347bca1'});
    var response = await http.get(url);

    AirResult result = AirResult.fromJson(convert.jsonDecode(response.body));

    return result;
  }

  @override
  void initState() {
    super.initState();

    fetchData().then((value) {
      setState(() {
        _airResult = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _airResult == null ? const Center(child: CircularProgressIndicator()) : Padding(
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
                          Text('${_airResult!.data!.current!.pollution!.aqius}', style: const TextStyle(fontSize: 40)),
                          Text(getString(_airResult!), style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                      color: getColor(_airResult!),
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.network('https://airvisual.com/images/${_airResult!.data!.current!.weather!.ic}.png', width: 32, height: 32,),
                              const SizedBox(
                                width: 16,
                              ),
                              Text('${_airResult!.data!.current!.weather!.tp}°', style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          Text('습도 ${_airResult!.data!.current!.weather!.hu}%'),
                          Text('풍속 ${_airResult!.data!.current!.weather!.ws}m/s'),
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
                      setState(() {

                      });
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
      ),
    );
  }

  Color getColor(AirResult airResult) {
    int? _aqius = airResult.data!.current!.pollution!.aqius;
    if (_aqius! <= 50) {
      return Colors.greenAccent;
    } else if (_aqius <= 100) {
      return Colors.yellow;
    } else if (_aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult airResult) {
    int? _aqius = airResult.data!.current!.pollution!.aqius;
    if (_aqius! <= 50) {
      return '좋음';
    } else if (_aqius <= 100) {
      return '보통';
    } else if (_aqius <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
