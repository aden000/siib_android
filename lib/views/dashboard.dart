import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:siib_android/views/template/dashboard_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> getDashboardData() async {
    var _ipVal = await _secureStorage.read(key: 'ip-config');
    var _jwtToken = await _secureStorage.read(key: 'jwt-token');
    var response;
    try {
      Map<String, String> requestHeader = {
        'Authorization': 'Bearer $_jwtToken'
      };
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
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    }
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        // leading: const Icon(Icons.home),
        title: const Text('SIIB | Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              _secureStorage.delete(key: 'jwt-token');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Login', (route) => false);
            },
            icon: const Icon(
              Icons.logout,
              semanticLabel: 'Logout',
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: getDashboardData(),
          builder: (
            BuildContext bc,
            AsyncSnapshot<Map<String, dynamic>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      DashboardMenu(
                        icon: Icons.list_rounded,
                        title: snapshot.data!['dashboard_data']['countBarang']
                            .toString(),
                        subtitle: 'Banyaknya barang yang tercatat di sistem',
                      ),
                      DashboardMenu(
                        icon: Icons.archive,
                        title: snapshot.data!['dashboard_data']
                                ['countBarangMasuk']
                            .toString(),
                        subtitle: 'Banyaknya terjadi barang masuk',
                      ),
                      DashboardMenu(
                        icon: Icons.unarchive,
                        title: snapshot.data!['dashboard_data']
                                ['countBarangKeluar']
                            .toString(),
                        subtitle: 'Banyaknya terjadi barang keluar',
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: const [
                    DashboardMenu(
                      icon: Icons.list_rounded,
                      title: ':(',
                      subtitle: 'Tidak mendapat data..., mohon login',
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Container(
                      margin: const EdgeInsets.only(left: 7.0),
                      child: const Text("Loading..."),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
