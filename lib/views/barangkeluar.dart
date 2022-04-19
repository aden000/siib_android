import 'package:flutter/material.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_keluar_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class BarangKeluar extends StatefulWidget {
  const BarangKeluar({Key? key}) : super(key: key);

  @override
  State<BarangKeluar> createState() => _BarangKeluarState();
}

class _BarangKeluarState extends State<BarangKeluar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Barang Keluar'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getDataBarangKeluar(context),
        builder:
            (BuildContext bc, AsyncSnapshot<List<BarangKeluarModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext bc, int idx) {
                  return InkWell(
                    child: DashboardMenu(
                        icon: Icons.unarchive,
                        title: 'Oleh: ' + snapshot.data![idx].namaUser,
                        titleFontSize: 20.0,
                        subtitle: 'Kepada Unit Kerja: ' +
                            snapshot.data![idx].namaUnitKerja +
                            "\nPada Tanggal: " +
                            snapshot.data![idx].tanggalKeluar.toString()),
                  );
                });
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
