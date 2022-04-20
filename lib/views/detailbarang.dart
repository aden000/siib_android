import 'package:flutter/material.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/detail_barang_model.dart';
import 'package:siib_android/views/component/sidebar.dart';

class DetailBarang extends StatefulWidget {
  final int idBarang;
  const DetailBarang({
    Key? key,
    required this.idBarang,
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
        title: const Text('SIIB | Detail Barang'),
        backgroundColor: Colors.blue[400],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: FutureBuilder(
          future: getDataDetailBarang(idBarang),
          builder: (
            BuildContext bc,
            AsyncSnapshot<List<DetailBarangModel>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Container();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal mendapatkan data')));
                return Container();
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
