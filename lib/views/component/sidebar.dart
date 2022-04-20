import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/views/template/dashboard_card.dart';
import 'package:siib_android/views/template/menu_card.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final _secureStorage = const FlutterSecureStorage();

  var role = 0;
  var idUser = 0;
  var namaUser = '';
  // var currentRoute = '';

  @override
  void initState() {
    super.initState();
    getLocalSessionData(context);
  }

  Future<Map<String, dynamic>> getLocalSessionData(BuildContext context) async {
    final jwtToken = await _secureStorage.read(key: 'jwt-token');
    var jwtPart = jwtToken!.split('.');
    var normalizedJWTpart = base64.normalize(jwtPart[1]);
    var payload = utf8.decode(base64.decode(normalizedJWTpart));
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    setState(() {
      idUser = int.parse(payloadMap['id_user']);
      role = int.parse(payloadMap['role']);
      namaUser = payloadMap['nama_user'];
      // currentRoute = ModalRoute.of(context)!.settings.name!;
    });

    return payloadMap;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // FutureBuilder(
          //   future: getLocalSessionData(),
          //   builder: (
          //     BuildContext bc,
          //     AsyncSnapshot<Map<String, dynamic>> snapshot,
          //   ) {
          //     dynamic a;
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       // return MenuCard(
          //       //   icon: Icons.person,
          //       //   name: snapshot.data!['nama_user'],
          //       //   route: '/UserInfo',
          //       // );
          //       a =
          //     } else {
          //       a = const MenuCard(
          //         icon: Icons.person,
          //         name: 'Loading...',
          //       );
          //     }
          //     return a;
          //   },
          // ),
          const SizedBox(
            height: 30.0,
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/UserInfo'),
            child: DashboardMenu(
              icon: Icons.person,
              title: namaUser,
              titleFontSize: 20.0,
              subtitle: 'Buka informasi user',
              subtitleFontSize: 13.0,
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.home_rounded),
            onTap: () => Navigator.popAndPushNamed(context, '/Dashboard'),
          ),
          ListTile(
            title: const Text('Daftar Barang'),
            leading: const Icon(Icons.list),
            onTap: () => Navigator.popAndPushNamed(context, '/DaftarBarang'),
            enabled: (role == 1 || role == 2),
          ),
          ListTile(
            title: const Text('Barang Keluar'),
            leading: const Icon(Icons.unarchive),
            onTap: () => Navigator.popAndPushNamed(context, '/BarangKeluar'),
            enabled: (role == 1 || role == 2),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: const Text('Log out / Keluar Sistem'),
              leading: const Icon(Icons.logout),
              onTap: () => logoutFunc(context),
            ),
          ))
        ],
      ),
    );
  }
}
