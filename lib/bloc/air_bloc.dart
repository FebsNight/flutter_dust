import 'package:flutter_dust/models/air_result.dart';
import 'package:flutter_dust/resources/air_api_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:rxdart/rxdart.dart';

class AirBloc {

  final _repository = AirApiProvider();
  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  void fetch() async {
    print('refresh');
    var airResult = await _repository.fetchAirResult();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;

}