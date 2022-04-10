import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> getLocalIPConfig() async {
  const _secureStorage = FlutterSecureStorage();
  var _ipConfig = await _secureStorage.read(key: 'ip-config');
  return _ipConfig!;
}

Future<String> getSavedJWTToken() async {
  const _secureStorage = FlutterSecureStorage();
  var _jwt = await _secureStorage.read(key: 'jwt-token');
  return _jwt!;
}

void setJWTToken(String jwtString) async {
  const _secureStorage = FlutterSecureStorage();
  await _secureStorage.write(key: 'jwt-token', value: jwtString);
}

Future<Map<String, dynamic>> getDataUser(BuildContext context) async {
  var _jwtToken = await getSavedJWTToken();
  var _ipVal = await getLocalIPConfig();
  var _payload = _jwtToken.split('.')[1];
  var _dataPayload =
      jsonDecode(utf8.decode(base64.decode(base64.normalize(_payload))));

  dynamic response;
  try {
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    response = await http.post(
      Uri.parse('http://$_ipVal/api/user'),
      headers: requestHeader,
      body: {
        'id_user': _dataPayload['id_user'],
        'android': 'true',
      },
    ).timeout(const Duration(seconds: 10));
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
  // print(response);
  if (response.statusCode == 200) {
    // print(response.body);
    return jsonDecode(response.body);
  } else {
    return <String, dynamic>{};
  }
}

void loginFunc(String username, String password, BuildContext context) async {
  // try {
  var ipVal = await getLocalIPConfig();
  if (username.isNotEmpty && password.isNotEmpty && ipVal.isNotEmpty) {
    // print('http://' + ipVal + '/api/auth/login');
    dynamic response;
    try {
      response = await http.post(
        Uri.parse('http://$ipVal/api/auth/login'),
        body: {
          'uname': username,
          'pword': password,
          'android': 'true',
        },
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Timeout - ' + e.toString()),
        ),
      );
      Navigator.pop(context);
      return;
    }
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print(result['jwt_token']);
      print(result['user_agent']);
      final jwtToken = result['jwt_token'];
      // await _secureStorage.write(key: 'jwt-token', value: jwtToken);
      setJWTToken(jwtToken);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
          context, '/Dashboard', (route) => false);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Username atau password salah'),
        ),
      );
      // print(response.body);
    }
  } else {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Harap masukan semua isian, dan pengaturan koneksi website'),
      ),
    );
  }
}