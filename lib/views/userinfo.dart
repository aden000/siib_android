// import 'dart:convert';

import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/views/component/sidebar.dart';
// import 'package:siib_android/views/template/dashboard_card.dart';
import 'package:siib_android/views/template/divider_withnamed.dart';
// import 'package:siib_android/views/template/menu_card.dart';

// import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();
  var newPassConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text('User Setting'),
      ),
      body: FutureBuilder(
        future: getDataUser(context),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: 150.0,
                        height: 150.0,
                        child: Center(
                          child: Text(
                            snapshot.data!['userdata']['nama_user']
                                .toString()[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 80.0,
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 20.0),
                  //     child: Text(
                  //       snapshot.data!['userdata']['nama_user'],
                  //       style: const TextStyle(
                  //           fontSize: 30.0,
                  //           fontWeight: FontWeight.w600,
                  //           color: Color.fromRGBO(49, 154, 244, 1.0)),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: const DividerWithNamed(
                      name: "Info Pengguna",
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Card(
                              child: Container(
                                height: 120.0,
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text("Nama Pengguna"),
                                        Expanded(
                                          child: Text(
                                            snapshot.data!['userdata']
                                                ['nama_user'],
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black45,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text("Username"),
                                        Expanded(
                                          child: Text(
                                            snapshot.data!['userdata']
                                                ['username'],
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black45,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text("Akses"),
                                        Expanded(
                                          child: Text(
                                            snapshot.data!['userdata']
                                                        ['role'] ==
                                                    '1'
                                                ? 'Pusat Sistem Informasi'
                                                : snapshot.data!['userdata']
                                                            ['role'] ==
                                                        '2'
                                                    ? 'Bagian Keuangan'
                                                    : snapshot.data!['userdata']
                                                                ['role'] ==
                                                            '3'
                                                        ? 'Yayasan'
                                                        : 'Tidak Terdefinisi',
                                            textAlign: TextAlign.right,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: const DividerWithNamed(
                      name: 'Ubah Password',
                    ),
                  ),

                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 70.0,
                        child: TextFormField(
                          controller: oldPassController,
                          decoration:
                              const InputDecoration(labelText: 'Password Lama'),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 70.0,
                        child: TextFormField(
                          controller: newPassController,
                          decoration:
                              const InputDecoration(labelText: 'Password Baru'),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 70.0,
                        child: TextFormField(
                          controller: newPassConfirmController,
                          decoration: const InputDecoration(
                              labelText: 'Ulangi Password Baru'),
                          obscureText: true,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        showLoaderDialog(context);
                        var _oldPass = oldPassController.text;
                        var _newPass = newPassController.text;
                        var _newPassConfirm = newPassConfirmController.text;
                        oldPassController.clear();
                        newPassController.clear();
                        newPassConfirmController.clear();

                        var result = await updatePassword(
                          context,
                          _oldPass,
                          _newPass,
                          _newPassConfirm,
                        );

                        if (result || !result) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Ubah Password'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color?>(
                          Colors.red[400],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
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
        },
      ),
    );
  }
}
