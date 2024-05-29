import 'package:get/get.dart';

String? extractMessage(Response response) {
  return response.body['message'];
}

dynamic extractData(Response response) {
  return response.body['data'];
}