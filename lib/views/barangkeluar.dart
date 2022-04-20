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
  String _searchValue = '';
  final _searchController = TextEditingController();
  // ListView myListView = ListView();
  // List<BarangKeluarModel> _forSearch = [];
  // List<BarangKeluarModel> _allDataBarKel = [];
  // final List<BarangKeluarModel> _dupBaseSearch = [];

  // void _searchBarKel(String query) {
  //   var suggestion = _allDataBarKel.where((element) {
  //     // final yangMelakukan = element.namaUser.toLowerCase();
  //     final olehUnitKerja = element.namaUnitKerja.toLowerCase();

  //     final input = query.toLowerCase();

  //     return olehUnitKerja.contains(input);
  //   }).toList();
  //   setState(() {
  //     _allDataBarKel.clear();
  //     _allDataBarKel.addAll(suggestion);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Barang Keluar'),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: SizedBox(
                height: 70.0,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Pencarian',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                setState(() {
                                  _searchController.clear();
                                  _searchValue = '';
                                });
                              }
                            },
                            icon: const Icon(Icons.clear))
                        : const SizedBox(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: FutureBuilder(
                future: getDataBarangKeluar(context),
                builder: (BuildContext bc,
                    AsyncSnapshot<List<BarangKeluarModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext bc, int idx) {
                        // print("Data Search: $_searchValue");
                        return snapshot.data![idx].namaUnitKerja
                                    .toLowerCase()
                                    .contains(_searchValue.toLowerCase()) ||
                                snapshot.data![idx].namaUser
                                    .toLowerCase()
                                    .contains(_searchValue.toLowerCase())
                            // snapshot.data![idx].namaUser
                            //     .contains(_searchValue) ||
                            // snapshot.data![idx].tanggalKeluar
                            //     .toString()
                            //     .contains(_searchValue)
                            ? InkWell(
                                child: DashboardMenu(
                                    icon: Icons.unarchive,
                                    title:
                                        'Oleh: ' + snapshot.data![idx].namaUser,
                                    titleFontSize: 20.0,
                                    subtitle: 'Kepada Unit Kerja: ' +
                                        snapshot.data![idx].namaUnitKerja +
                                        "\nPada Tanggal: " +
                                        snapshot.data![idx].tanggalKeluar
                                            .toString()),
                              )
                            : Container();
                      },
                    );
                    // return myListView;
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
          ),
        ],
      ),
    );
  }
}
