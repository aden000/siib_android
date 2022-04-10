import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:siib_android/connection/connection.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _username;
  late TextEditingController _password;
  final _secureStorage = const FlutterSecureStorage();
  final _ipConfigure = TextEditingController();

  bool isLoading = false;

  Future<bool> checkIsHaveSession() async {
    isLoading = true;
    var loggedInID = await _secureStorage.read(key: 'jwt-token');
    if (loggedInID != null) {
      isLoading = false;
      Navigator.pushNamedAndRemoveUntil(
          context, '/Dashboard', (route) => false);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    checkIsHaveSession();

    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _username.dispose();
    _password.dispose();
    _ipConfigure.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Login Page'),
        actions: [
          IconButton(
            onPressed: () async {
              var ipVal = await _secureStorage.read(key: 'ip-config');
              if (ipVal != null) {
                _ipConfigure.text = ipVal.toString();
              }
              final ip = await _ipConfigDialog();
              if (ip == null || ip.isEmpty) return;

              setState(() {
                _secureStorage.write(key: 'ip-config', value: ip);
              });
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  flex: 6,
                  child: Text(
                    'Selamat Datang di SIIB',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextField(
              controller: _username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukan Username',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukan Password',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color?>(Colors.grey[300]),
              ),
              onPressed: () {
                loginFunc(_username.text, _password.text, context);
                showLoaderDialog(context);
              },
              child: const Text('LOGIN'),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _ipConfigDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ubah Konfigurasi IP'),
          content: TextField(
            autofocus: true,
            controller: _ipConfigure,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '000.000.000.000 / Website',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_ipConfigure.text);
              },
              child: const Text('SET'),
            ),
          ],
        ),
      );
}
