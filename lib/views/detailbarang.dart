import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/detail_barang_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class DetailBarang extends StatefulWidget {
  final int idBarang;
  final String namaBarang;
  const DetailBarang({
    Key? key,
    required this.idBarang,
    required this.namaBarang,
  }) : super(key: key);

  @override
  State<DetailBarang> createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> {
  late int idBarang;
  // var _result;
  @override
  void initState() {
    super.initState();
    idBarang = widget.idBarang;
    // _result = await getDataDetailBarang(idBarang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SIIB | Detail Barang'),
            Text(
              widget.namaBarang,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: FutureBuilder(
          future: getDataDetailBarang(context, idBarang),
          builder: (
            BuildContext bc,
            AsyncSnapshot<List<DetailBarangModel>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext bc, int idx) {
                    return DashboardMenu(
                      icon: FontAwesomeIcons.cube,
                      title: snapshot.data![idx].kuantitas.toString(),
                      subtitle: snapshot.data![idx].namaSatuan,
                    );
                  },
                );
              } else {
                return Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        FontAwesomeIcons.faceSadTear,
                        size: 40.0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: const Text(
                          "Tidak ada detail barang...",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
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
          },
        ),
      ),
    );
  }
}
