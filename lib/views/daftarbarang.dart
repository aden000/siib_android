import 'package:flutter/material.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/detailbarang.dart';
import 'package:siib_android/views/template/dashboard_card.dart';

class DaftarBarang extends StatefulWidget {
  const DaftarBarang({Key? key}) : super(key: key);

  @override
  State<DaftarBarang> createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  String _searchValue = '';
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Daftar Barang'),
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, right: 20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
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
            Expanded(
              child: FutureBuilder(
                future: getDataBarang(context),
                builder: (BuildContext bc,
                    AsyncSnapshot<List<BarangModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext bc, int idx) {
                        return snapshot.data![idx].namaBarang
                                    .toLowerCase()
                                    .contains(_searchValue.toLowerCase()) ||
                                snapshot.data![idx].namaKategoriBarang
                                    .toLowerCase()
                                    .contains(_searchValue.toLowerCase())
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBarang(
                                        idBarang: snapshot.data![idx].idBarang,
                                      ),
                                    ),
                                  );
                                },
                                child: DashboardMenu(
                                  icon: Icons.art_track,
                                  title: snapshot.data![idx].namaBarang,
                                  titleFontSize: 20.0,
                                  subtitle:
                                      snapshot.data![idx].namaKategoriBarang,
                                ),
                              )
                            : Container();
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
            ),
          ],
        ),
      ),
    );
  }
}
