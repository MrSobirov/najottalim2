import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class HttpResult {
  final bool isSuccess;
  final int status;
  final String body;

  HttpResult(this.isSuccess, this.status, this.body);
}

class ApiRequests {
  static Future<HttpResult> _result(response) async {
    dynamic body = response.body;
    int status = response.statusCode ?? 404;
    if(response.statusCode >= 200 && response.statusCode <= 299){
      return HttpResult(true, status, body);
    } else {
      return HttpResult(false, status, body);
    }
  }

  Future<HttpResult> get({required String slug}) async {
    Uri url = Uri.parse(slug);
    try{
      final response =  await http.get(url);
      return _result(response);
    } on TimeoutException catch (error) {
      log("TimeOutException: $error");
      return _result({});
    } on SocketException catch (error) {
      log("SocketException: $error");
      return _result({});
    } catch (error) {
      log("Unexpected post error: $error");
      return _result({});
    }
  }
}