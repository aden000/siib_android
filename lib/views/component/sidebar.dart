import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/views/template/menu_card.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getLocalSessionData();
  }

  Future<Map<String, dynamic>> getLocalSessionData() async {
    final jwtToken = await _secureStorage.read(key: 'jwt-token');
    var jwtPart = jwtToken!.split('.');
    var normalizedJWTpart = base64.normalize(jwtPart[1]);
    var payload = utf8.decode(base64.decode(normalizedJWTpart));
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder(
            future: getLocalSessionData(),
            builder: (
              BuildContext bc,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                return MenuCard(
                  icon: Icons.person,
                  name: snapshot.data!['nama_user'],
                  route: '/UserInfo',
                );
              } else {
                return const MenuCard(
                  icon: Icons.person,
                  name: 'Loading...',
                );
              }
            },
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.home_rounded),
            onTap: () => Navigator.popAndPushNamed(context, '/Dashboard'),
          ),
          const ListTile(
            title: Text('Daftar Barang'),
            leading: Icon(Icons.list),
          ),
          const ListTile(
            title: Text('Tambah Barang Keluar'),
            leading: Icon(Icons.add_to_photos_outlined),
          ),
        ],
      ),
    );
  }
}
