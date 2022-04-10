// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/views/template/dashboard_card.dart';
import 'package:siib_android/views/template/menu_card.dart';

// import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _secureStorage = const FlutterSecureStorage();
  Map<String, dynamic> userData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Setting'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: getDataUser(context),
              builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        DashboardMenu(
                          icon: Icons.perm_identity,
                          title: snapshot.data!['userdata']['nama_user'],
                          titleFontSize: 30.0,
                          subtitle: snapshot.data!['userdata']['username'],
                        ),
                        const MenuCard(
                          icon: Icons.perm_identity,
                          name: 'Ubah Info User',
                        ),
                        const MenuCard(
                          icon: Icons.vpn_key_outlined,
                          name: 'Ubah Password',
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircularProgressIndicator(),
                            Container(
                                margin: const EdgeInsets.only(left: 7.0),
                                child: const Text("Loading...")),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
