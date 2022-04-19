import 'package:flutter/material.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class DaftarBarang extends StatefulWidget {
  const DaftarBarang({Key? key}) : super(key: key);

  @override
  State<DaftarBarang> createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Daftar Barang'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: getDataBarang(context),
        builder: (BuildContext bc, AsyncSnapshot<List<BarangModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext bc, int idx) {
                return InkWell(
                  onTap: () {},
                  child: DashboardMenu(
                    icon: Icons.art_track,
                    title: snapshot.data![idx].namaBarang,
                    titleFontSize: 20.0,
                    subtitle: snapshot.data![idx].namaKategoriBarang,
                  ),
                );
              },
            );
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
