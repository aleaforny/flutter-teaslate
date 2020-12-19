library flutter_teaslate;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/cupertino.dart';

class TeaSlate {
  static const String apiUrl = "https://teaslate.twiiky.fr/api/translations/json";
  final String key;
  final bool debug;
  final bool ignoreCertErrors;
  bool isConnected = false;
  List<dynamic> translations;

  TeaSlate({@required this.key, this.debug = false, this.ignoreCertErrors = false});

  Future<http.Response> _getAllTranslations() async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Token $key',
      };

      if (debug)
        print("Will attempt to get $apiUrl with headers $headers");

      HttpClient client = HttpClient();
      if (ignoreCertErrors)
        client = HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      var ioClient = IOClient(client);

      final http.Response response = await ioClient.get(apiUrl, headers: headers).timeout((const Duration(seconds: 10)));

      if (debug) {
        print("GET Response status: ${response.statusCode}");
        print("GET Response body: ${response.body}");
      }

      ioClient.close();

      return response;
    } on TimeoutException catch (_) {
      Map<String, dynamic> error = {
        'error': 'Timeout server',
      };

      if (debug)
        print("GET Timeout $_");

      return http.Response(json.encode(error), 504);
    } on SocketException catch (_) {
      if (debug)
        print("GET Internal Server Error $_");
      return _getAllTranslations();
    } catch (e) {
      if (debug)
        print("POST Unhandled error $e");
      return _getAllTranslations();
    }
  }

  Future<bool> connect() async {
    if (isConnected)
      throw Exception("already connected");

    http.Response response = await _getAllTranslations();

    if (response.statusCode == 200) {
      translations = json.decode(response.body);
      isConnected = true;
    } else if (response.statusCode == 400) {
      if (debug)
        print("error ${response.statusCode} - ${json.decode(response.body)['error']}");
    } else {
      if (debug)
        print("error ${response.statusCode} - ${json.decode(response.body)}");
    }

    return isConnected;
  }

  String translate(String uid, {@required String lang}) {
    if (isConnected) {
      List<dynamic> translationsFound = translations.where((translation) => translation['uid'] == uid).toList();
      if (translationsFound.length == 1) {
        List<dynamic> translationsTexts = translationsFound.first['translation_set'].where((translation) => doesContain(translation['lang'], lang)).toList();
        if (translationsTexts.length == 1) {
          return translationsTexts.first['default'];
        } else {
          return translationsFound.first['translation_set'].first['default'];
        }
      } else {
        throw Exception("UID $uid couldn't be found!");
      }
    } else {
      throw Exception("not connected to API");
    }
  }
}

bool doesContain(String data, String containsText) {
  return data.contains(containsText);
}