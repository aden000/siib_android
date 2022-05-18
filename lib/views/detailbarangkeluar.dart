import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/detail_barang_keluar_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class DetailBarangKeluar extends StatefulWidget {
  final int idBarangKeluar;
  final String yangMengajukan;
  final DateTime tanggalKeluar;
  final int status;
  const DetailBarangKeluar(
      {Key? key,
      required this.idBarangKeluar,
      required this.yangMengajukan,
      required this.tanggalKeluar,
      required this.status})
      : super(key: key);

  @override
  State<DetailBarangKeluar> createState() => _DetailBarangKeluarState();
}

class _DetailBarangKeluarState extends State<DetailBarangKeluar> {
  late int idBarangKeluar;
  @override
  void initState() {
    super.initState();
    idBarangKeluar = widget.idBarangKeluar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.status == 0
            ? FloatingActionButton.extended(
                onPressed: () async {
                  dynamic agree = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              "Apakah anda yakin untuk mengubah status barang keluar ini?, barang keluar yang telah diubah statusnya tidak bisa diubah kembali"),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Tidak"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[400])),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("Ya"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          Colors.green[400])),
                            )
                          ],
                        );
                      });

                  if (agree != null) {
                    if (agree == true) {
                      showLoaderDialog(context);
                      bool result = await updateStatus(context, idBarangKeluar);
                      if (result == true) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/BarangKeluar', (route) => false);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                label: const Text("Ubah Status"),
                icon: const Icon(FontAwesomeIcons.check),
              )
            : Container(),
        drawer: const Sidebar(),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIIB | Detail Barang Keluar | BK' +
                    widget.idBarangKeluar.toString().padLeft(4, '0'),
                style: const TextStyle(fontSize: 16.0),
              ),
              Text(
                widget.yangMengajukan +
                    ' | ' +
                    DateFormat.yMMMMd().add_Hm().format(widget.tanggalKeluar),
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
          backgroundColor: Colors.blue[400],
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: FutureBuilder(
              future: getDetailBarangKeluar(context, idBarangKeluar),
              builder: (
                BuildContext bc,
                AsyncSnapshot<List<DetailBarangKeluarModel>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext bc, int idx) {
                        return DashboardMenu(
                          icon: FontAwesomeIcons.cube,
                          title: snapshot.data![idx].namaBarang,
                          titleFontSize: 18.0,
                          subtitle: snapshot.data![idx].kuantitas.toString() +
                              ' ' +
                              snapshot.data![idx].namaSatuan,
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
            )));
  }
}
