import 'package:flutter/material.dart';
import 'package:siib_android/views/barangkeluar.dart';
import 'package:siib_android/views/daftarbarang.dart';
import 'package:siib_android/views/dashboard.dart';
import 'package:siib_android/views/login.dart';
import 'package:siib_android/views/userinfo.dart';

void main() {
  runApp(MaterialApp(
    title: 'SIIB Mobile | ITATS',
    home: const Login(),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
      '/Login': (BuildContext context) => const Login(),
      '/Dashboard': (BuildContext context) => const Dashboard(),
      '/UserInfo': (BuildContext context) => const UserInfo(),
      '/DaftarBarang': (BuildContext context) => const DaftarBarang(),
      '/BarangKeluar': (BuildContext context) => const BarangKeluar(),
    },
  ));
}
