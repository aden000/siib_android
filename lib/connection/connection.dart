import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/model/barang_keluar_model.dart';
import 'package:siib_android/model/barang_model.dart';
import 'package:siib_android/model/detail_barang_keluar_model.dart';
import 'package:siib_android/model/detail_barang_model.dart';
import 'package:siib_android/model/satuan_model.dart';
import 'package:siib_android/model/unit_kerja_model.dart';

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

Future<Map<String, dynamic>> getDashboardData(BuildContext context) async {
  var _ipVal = await getLocalIPConfig();
  var _jwtToken = await getSavedJWTToken();
  var response;
  try {
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    response = await http.post(
      Uri.parse('http://$_ipVal/api/dashboard'),
      headers: requestHeader,
      body: {
        'android': 'true',
      },
    ).timeout(const Duration(seconds: 10));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error : ' + e.toString(),
        ),
      ),
    );
  }
  if (response != null && response.statusCode == 200) {
    // print(response.body);
    return jsonDecode(response.body);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Error : Tidak mendapat data, mohon login ulang',
        ),
      ),
    );
    logoutFunc(context);
    return {};
  }
}

Future<bool> updateStatus(BuildContext context, int idBarangKeluar) async {
  String _jwtToken = await getSavedJWTToken();
  String _ipVal = await getLocalIPConfig();

  http.Response response;
  Map<String, String> reqHead = {'Authorization': 'Bearer $_jwtToken'};
  try {
    response = await http.post(
      Uri.parse('http://$_ipVal/api/barang/keluar/ubah-status'),
      headers: reqHead,
      body: {
        'android': 'true',
        'idBarKel': '$idBarangKeluar',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error : Internal server error, ErrCode: #ConnUpdStatusUnexpectedResponseStatusCode',
          ),
        ),
      );
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  }

  return false;
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
      print(result['jwt_token']);
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
      Uri.parse('http://$_ipVal/api/barang/get'),
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

@Deprecated("Use getDataBarangKeluarNew")
Future<List<BarangKeluarModel>> getDataBarangKeluar(
    BuildContext context) async {
  var _ipVal = await getLocalIPConfig();
  var _response;
  try {
    var _jwtToken = await getSavedJWTToken();
    Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
    _response = await http.post(
      Uri.parse('http://$_ipVal/api/barang/keluar/get'),
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

Future<Map<String, dynamic>> getDataBarangKeluarNew(BuildContext bc,
    {int? page, String? search, Map<String, int?>? filterDate}) async {
  bool usingFromTo = (filterDate != null &&
      filterDate['from'] != null &&
      filterDate['to'] != null);
  var _ipVal = await getLocalIPConfig();
  var _jwtToken = await getSavedJWTToken();
  Map<String, String> requestHeader = {'Authorization': 'Bearer $_jwtToken'};
  http.Response response;
  try {
    page ?? 1;
    if (search == null) {
      String url;
      if (!usingFromTo) {
        url = 'http://$_ipVal/api/barang/keluar/get?page=$page&android=true';
      } else {
        int? from = filterDate["from"];
        int? to = filterDate["to"];

        url =
            'http://$_ipVal/api/barang/keluar/get?page=$page&android=true&from=$from&to=$to';
      }
      response = await http.get(
        Uri.parse(url),
        headers: requestHeader,
      );
    } else {
      String url;
      if (!usingFromTo) {
        url =
            'http://$_ipVal/api/barang/keluar/get?page=$page&android=true&search=$search';
      } else {
        int? from = filterDate["from"];
        int? to = filterDate["to"];
        url =
            'http://$_ipVal/api/barang/keluar/get?page=$page&android=true&search=$search&from=$from&to=$to';
      }
      response = await http.get(
        Uri.parse(url),
        headers: requestHeader,
      );
    }
    print(response.statusCode);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return {};
    }
  } catch (e) {
    ScaffoldMessenger.of(bc)
        .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    return {};
  }
}

Future<List<DetailBarangModel>> getDataDetailBarang(
    BuildContext context, int idBarang) async {
  var _jwtToken = await getSavedJWTToken();
  var _ipAddress = await getLocalIPConfig();

  Map<String, String> reqHeader = {'Authorization': 'Bearer $_jwtToken'};
  var response;
  try {
    response = await http.post(
      Uri.parse('http://$_ipAddress/api/barang/detail/${idBarang.toString()}'),
      body: {
        'android': 'true',
      },
      headers: reqHeader,
    );
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  }
  if (response != null && response.statusCode == 200) {
    List<DetailBarangModel> list = [];
    for (var item in jsonDecode(response.body)['detailBarangList']) {
      list.add(DetailBarangModel.fromJson(item));
    }
    return list;
  } else {
    return [];
  }
}

Future<List<DetailBarangKeluarModel>> getDetailBarangKeluar(
    BuildContext context, int idBarangKeluar) async {
  var _jwtToken = await getSavedJWTToken();
  var _ipAddress = await getLocalIPConfig();

  Map<String, String> reqHeader = {'Authorization': 'Bearer $_jwtToken'};
  var response;
  try {
    response = await http.post(
      Uri.parse(
          'http://$_ipAddress/api/barang/keluar/detail/${idBarangKeluar.toString()}'),
      body: {
        'android': 'true',
      },
      headers: reqHeader,
    );
    if (response != null && response.statusCode == 200) {
      List<DetailBarangKeluarModel> ldbkm = [];
      for (var item in jsonDecode(response.body)['detailBarangKeluarList']) {
        ldbkm.add(DetailBarangKeluarModel.fromJson(item));
      }
      return ldbkm;
    } else {
      return [];
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
  }
  return [];
}

Future<List<UnitKerjaModel>> getDataUnitKerja(BuildContext context) async {
  var _ip = await getLocalIPConfig();
  var _jwtToken = await getSavedJWTToken();

  Map<String, String> reqHeader = {'Authorization': 'Bearer $_jwtToken'};
  http.Response response;
  try {
    response = await http.post(
      Uri.parse('http://$_ip/api/unit-kerja/get'),
      headers: reqHeader,
      body: {
        'android': 'true',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<UnitKerjaModel> lukm = [];
      for (var item in jsonDecode(response.body)['unit_kerja']) {
        lukm.add(UnitKerjaModel.fromJson(item));
      }
      return lukm;
    } else {
      return [];
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
      ),
    );
    return [];
  }
}

Future<List<SatuanModel>> getDataSatuanByIdBarang(
    BuildContext context, int idBarang) async {
  var _ip = await getLocalIPConfig();
  var _jwtToken = await getSavedJWTToken();

  Map<String, String> reqHeader = {'Authorization': 'Bearer $_jwtToken'};
  http.Response response;
  try {
    response = await http.post(
      Uri.parse('http://$_ip/api/barang/detail/$idBarang'),
      headers: reqHeader,
      body: {
        'android': 'true',
      },
    );
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<SatuanModel> lsm = [];
      for (var item in jsonDecode(response.body)['detailBarangList']) {
        lsm.add(SatuanModel.fromJson(item));
      }
      return lsm;
    } else {
      return [];
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
      ),
    );
    return [];
  }
}

Future<Map<String, String>> sendBarangKeluar(
  BuildContext context,
  String unitKerja,
  List<String> barangList,
  List<String> satuanList,
  List<String> qtyList,
) async {
  var _ip = await getLocalIPConfig();
  var _jwtToken = await getSavedJWTToken();

  Map<String, String> reqHeader = {
    'Authorization': 'Bearer $_jwtToken',
  };

  final Map<String, String> body = {
    "android": "true",
    "unitKerja": unitKerja,
  };
  for (int i = 0; i < barangList.length; i++) {
    body['brng[$i]'] = barangList[i];
    body['satuan[$i]'] = satuanList[i];
    body['qty[$i]'] = qtyList[i];
  }

  // print(body.toString());
  // return false;
  http.Response response;
  try {
    response = await http.post(
      Uri.parse('http://$_ip/api/barang/keluar/create'),
      headers: reqHeader,
      body: body,
    );
    if (response.statusCode == 201) {
      print(response.body);
      return {
        "success": "true",
      };
    } else {
      print(response.body);
      return json.decode(response.body);
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
      ),
    );
    return {"success": "false", "message": e.toString()};
  }
}
