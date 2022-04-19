// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';
import 'package:siib_android/views/template/menu_card.dart';

// import 'package:http/http.dart' as http;

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  var namaUserController = TextEditingController();
  var userNameController = TextEditingController();

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
        future: getDataUser(context, {
          'nama_user': namaUserController,
          'username': userNameController,
        }),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Icon(
                        Icons.person,
                        size: 150.0,
                        color: Color.fromRGBO(49, 154, 244, 1.0),
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: SizedBox(
                        height: 70.0,
                        child: TextFormField(
                          controller: namaUserController,
                          decoration:
                              const InputDecoration(labelText: 'Nama Pengguna'),
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
                          controller: userNameController,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Terapkan perubahan'),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Ubah Password'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.red[400],
                            ),
                          ),
                        )
                      ],
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
