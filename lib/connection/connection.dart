import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/model/barang_keluar_model.dart';
import 'package:siib_android/model/barang_model.dart';
import 'package:siib_android/model/detail_barang_model.dart';

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

void removeJWTToken() async {
  const _secureStorage = FlutterSecureStorage();
  await _secureStorage.delete(key: 'jwt-token');
}

void showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7.0),
            child: const Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> updatePassword(BuildContext context, String _oldPass,
    String _newPass, String _newPassConfirm) async {
  var _jwtToken = await getSavedJWTToken();
  var _ipVal = await getLocalIPConfig();

  http.Response response;
  try {
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    response = await http.post(
      Uri.parse('http://$_ipVal/api/auth/changepass'),
      headers: requestHeader,
      body: {
        'android': 'true',
        'oldpass': _oldPass,
        'newpass': _newPass,
        'newpassconfirm': _newPassConfirm,
      },
    );
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Perubahan Password Berhasil, silahkan login ulang untuk menggunakan password baru")));
      return true;
    } else {
      var _result = jsonDecode(response.body);
      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${_result['messages']['error']}")));
      return false;
    }
  } catch (e) {
    // Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  }
  //to be continued
  return false;
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
    var result = jsonDecode(response.body);
    // if (option.isNotEmpty) {
    //   TextEditingController namaUserController = option['nama_user']!;
    //   TextEditingController userNameController = option['username']!;

    //   namaUserController.text = result['userdata']['nama_user'];
    //   userNameController.text = result['userdata']['username'];
    // }
    return result;
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
      // print(result['jwt_token']);
      // print(result['user_agent']);
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

void logoutFunc(BuildContext context) {
  removeJWTToken();
  Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
}

Future<List<BarangModel>> getDataBarang(BuildContext context) async {
  var _ipVal = await getLocalIPConfig();
  var response;
  try {
    var _jwtToken = await getSavedJWTToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    response = await http.post(
      Uri.parse('http://$_ipVal/api/barang/daftar-barang'),
      headers: requestHeader,
      body: {'android': 'true'},
    );
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
  if (response.statusCode == 200) {
    var _result = jsonDecode(response.body);
    List<BarangModel> list = [];
    for (var item in _result['barang']) {
      list.add(BarangModel.fromJson(item));
    }
    return list;
  } else {
    return [];
  }
}

Future<List<BarangKeluarModel>> getDataBarangKeluar(
    BuildContext context) async {
  var _ipVal = await getLocalIPConfig();
  var _response;
  try {
    var _jwtToken = await getSavedJWTToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    _response = await http.post(
      Uri.parse('http://$_ipVal/api/barang/keluar'),
      headers: requestHeader,
      body: {'android': 'true'},
    );
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
  if (_response.statusCode == 200) {
    var _result = jsonDecode(_response.body);
    List<BarangKeluarModel> list = [];
    for (var item in _result['barang_keluar']) {
      list.add(BarangKeluarModel.fromJson(item));
    }
    return list;
  } else {
    return [];
  }
}

Future<List<DetailBarangModel>> getDataDetailBarang(int idBarang) async {
  return [];
}
