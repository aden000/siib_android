import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_keluar_model.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/detailbarangkeluar.dart';
import 'package:siib_android/views/template/dashboard_card.dart';
import 'package:siib_android/views/template/divider_withnamed.dart';
import 'package:siib_android/views/template/itembarkel.dart';

class BarangKeluar extends StatefulWidget {
  const BarangKeluar({Key? key}) : super(key: key);

  @override
  State<BarangKeluar> createState() => _BarangKeluarState();
}

class _BarangKeluarState extends State<BarangKeluar> {
  Map<String, int?> filter = {
    "from": null,
    "to": null,
  };

  List<BarangKeluarModel> lists = List.empty(growable: true);

  String _searchValue = '';
  int currpage = 1;
  int nextpage = 0;
  bool hasNext = false;
  bool isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    loadFirst();
  }

  void loadFirst() async {
    isLoading = true;
    Map<String, dynamic> result = await getDataBarangKeluarNew(context,
        page: currpage, search: _searchValue);
    for (var item in result['barang_keluar']) {
      lists.add(BarangKeluarModel.fromJson(item));
    }
    nextpage = result['nextPage'] ?? -1;
    setState(() {});
    isLoading = false;
  }

  void loadMore() async {
    if (nextpage != -1) {
      isLoading = true;
      currpage = nextpage;
      Map<String, dynamic> result = await getDataBarangKeluarNew(context,
          page: currpage, search: _searchValue);
      for (var item in result['barang_keluar']) {
        lists.add(BarangKeluarModel.fromJson(item));
      }
      nextpage = result['nextPage'] ?? -1;
      setState(() {});
      isLoading = false;
    }
  }

  void changedSearch() async {
    isLoading = true;
    currpage = 1;
    lists = [];
    Map<String, dynamic> result = await getDataBarangKeluarNew(context,
        page: currpage, search: _searchValue, filterDate: filter);
    for (var item in result['barang_keluar']) {
      lists.add(BarangKeluarModel.fromJson(item));
    }
    nextpage = result['nextPage'] ?? -1;
    setState(() {
      lists;
    });
    isLoading = false;
  }

  _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _searchValue = value;
      setState(() {
        changedSearch();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _searchController.dispose();
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Tambah Barang Keluar"),
        onPressed: () => Navigator.pushNamed(context, '/TambahBarangKeluar'),
        icon: const Icon(FontAwesomeIcons.plus),
      ),
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('SIIB | Barang Keluar'),
        actions: [
          IconButton(
              onPressed: () async {
                dynamic result = await showDialog(
                    context: context,
                    builder: (bc) {
                      return StatefulBuilder(
                        builder: (context, setState) => AlertDialog(
                          title: const Text("Ubah Filter"),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const DividerWithNamed(
                                  name: "Barang Keluar Awal",
                                  paddingLeft: 0.0,
                                  paddingRight: 0.0,
                                ),
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        filter['from'] == null
                                            ? "Pilih Barang Keluar Awal"
                                            : DateFormat.yMMMMd().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        (filter['from']! *
                                                            1000)),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red[400])),
                                        onPressed: () => showDatePicker(
                                                    context: bc,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2099))
                                                .then((value) {
                                              if (value != null &&
                                                  value.year != 0) {
                                                setState(() {
                                                  filter['from'] =
                                                      (value.millisecondsSinceEpoch /
                                                              1000)
                                                          .round();
                                                });
                                              }
                                            }),
                                        child: const Icon(
                                            FontAwesomeIcons.calendar))
                                  ],
                                ),
                                const DividerWithNamed(
                                  name: "Barang Keluar Akhir",
                                  paddingLeft: 0.0,
                                  paddingRight: 0.0,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        filter['to'] == null
                                            ? "Pilih Barang Keluar Akhir"
                                            : DateFormat.yMMMMd().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        filter['to']! * 1000)),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red[400])),
                                      onPressed: () => showDatePicker(
                                              context: bc,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2099))
                                          .then((value) {
                                        if (value != null && value.year != 0) {
                                          setState(() {
                                            filter['to'] =
                                                (value.millisecondsSinceEpoch /
                                                        1000)
                                                    .round();
                                          });
                                        }
                                      }),
                                      child:
                                          const Icon(FontAwesomeIcons.calendar),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop(filter);
                              },
                              child: const Text("Terapkan Filter"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                filter = {
                                  "from": null,
                                  "to": null,
                                };
                                Navigator.of(context).pop(filter);
                              },
                              child: const Text("Reset Tanggal"),
                            )
                          ],
                        ),
                      );
                    });

                if (result != null) {
                  print(result);
                  setState(() {
                    filter = result;
                    changedSearch();
                  });
                }
              },
              icon: const Icon(FontAwesomeIcons.filter)),
          const SizedBox(
            width: 5.0,
          )
        ],
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
                  onChanged: (value) => _onSearchChanged(value),
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
                                  changedSearch();
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    FontAwesomeIcons.solidSquareMinus,
                    color: Colors.yellow[600],
                  ),
                  const SizedBox(
                    width: 7.0,
                  ),
                  const Text("PROSES"),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Icon(
                    FontAwesomeIcons.solidSquareCheck,
                    color: Colors.green[400],
                  ),
                  const SizedBox(
                    width: 7.0,
                  ),
                  const Text("SELESAI"),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
              child: LazyLoadScrollView(
                onEndOfPage: () => loadMore(),
                isLoading: isLoading,
                child: !isLoading
                    ? ListView.builder(
                        itemCount: lists.length,
                        itemBuilder: (BuildContext bc, int idx) {
                          if (lists.isNotEmpty) {
                            if (idx == lists.length - 1 && nextpage > 0) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 7.0),
                                        child: const Text("Loading..."),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBarangKeluar(
                                        idBarangKeluar:
                                            lists[idx].idBarangKeluar,
                                        yangMengajukan:
                                            lists[idx].namaUnitKerja,
                                        tanggalKeluar: lists[idx].tanggalKeluar,
                                        status: lists[idx].status,
                                      ),
                                    ),
                                  );
                                },
                                child: ItemBarKel(
                                  icon: lists[idx].status == 0
                                      ? FontAwesomeIcons.solidSquareMinus
                                      : FontAwesomeIcons.solidSquareCheck,
                                  iconColor: lists[idx].status == 0
                                      ? Colors.yellow[600]
                                      : Colors.green[400],
                                  title: 'BK' +
                                      lists[idx]
                                          .idBarangKeluar
                                          .toString()
                                          .padLeft(4, '0'),
                                  titleFontSize: 20.0,
                                  oleh: lists[idx].namaUser,
                                  unitkerja: lists[idx].namaUnitKerja,
                                  tgl: DateFormat.yMMMMd()
                                      .add_Hm()
                                      .format(lists[idx].tanggalKeluar),
                                ),
                              );
                            }
                          } else {
                            return const Center(
                              child: ListTile(
                                title: Center(
                                  child: Text("Loading..."),
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : Center(
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
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
