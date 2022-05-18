import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_model_for_barkel.dart';
import 'package:siib_android/model/unit_kerja_model.dart';
import 'package:siib_android/views/component/barangkeluarform.dart';
import 'package:siib_android/views/component/sidebar.dart';
import 'package:siib_android/views/template/divider_withnamed.dart';

class TambahBarangKeluar extends StatefulWidget {
  const TambahBarangKeluar({Key? key}) : super(key: key);

  @override
  State<TambahBarangKeluar> createState() => _TambahBarangKeluarState();
}

class _TambahBarangKeluarState extends State<TambahBarangKeluar> {
  final _formTambahBarangKeluarKey = GlobalKey<FormBuilderState>();
  final List<BarangKeluarForm> forms = List.empty(growable: true);
  // late int _countBarang;

  // final TextEditingController unitKerja = TextEditingController();
  late Future<List<UnitKerjaModel>> unitKerja;

  @override
  void initState() {
    super.initState();
    unitKerja = getDataUnitKerja(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        floatingActionButton: forms.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () async {
                  if (_formTambahBarangKeluarKey.currentState!
                      .saveAndValidate()) {
                    // var values = _formTambahBarangKeluarKey.currentState!.value;

                    String unitKerja = _formTambahBarangKeluarKey.currentState!
                        .getRawValue("unitKerja")
                        .toString();
                    List<String> brng = [];
                    // String brngString = "[";
                    List<String> satuan = [];
                    // String satuanString = "[";
                    List<String> kuantitas = [];
                    // String kuantitasString = "[";
                    for (var i = 0; i < forms.length; i++) {
                      // brngString +=
                      //     forms[i].barModForBarKel.idBarang.toString();
                      brng.add(forms[i].barModForBarKel.idBarang.toString());
                      // satuanString +=
                      //     forms[i].barModForBarKel.idSatuan.toString();
                      satuan.add(forms[i].barModForBarKel.idSatuan.toString());
                      // kuantitasString +=
                      //     forms[i].barModForBarKel.kuantitas.toString();
                      kuantitas
                          .add(forms[i].barModForBarKel.kuantitas.toString());
                      // if ((i + 1) < forms.length) {
                      //   brngString += ",";
                      //   // brng.add(forms[i].barModForBarKel.idBarang.toString());
                      //   satuanString += ",";
                      //   // satuan.add(forms[i].barModForBarKel.idSatuan.toString());
                      //   kuantitasString += ',';
                      // }
                    }
                    // brngString += "]";
                    // satuanString += "]";
                    // kuantitasString += "]";

                    // Map<String, String> jsonBuilder = {
                    //   "android": "true",
                    //   "unitKerja": _formTambahBarangKeluarKey.currentState!
                    //       .getRawValue("unitKerja")
                    //       .toString(),
                    //   "brng": brngString,
                    //   "satuan": satuanString,
                    //   "qty": kuantitasString
                    // };

                    // print(jsonBuilder);
                    // print(kuantitas.toString());
                    // print(brng.toSet().toString());

                    // //make json
                    // String jsonEncodedString = jsonEncode(jsonBuilder);
                    // print(jsonEncodedString);

                    bool approve = await showDialog(
                      context: context,
                      builder: (builder) => AlertDialog(
                        title: const Text(
                            "Apakah anda yakin, data yang anda masukan sudah sesuai?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text("Ya dan Submit"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.blue[400],
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Batal"),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.red[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (approve == true) {
                      showLoaderDialog(context);
                      var sendAndAccept = await sendBarangKeluar(
                        context,
                        unitKerja,
                        brng,
                        satuan,
                        kuantitas,
                      );
                      if (sendAndAccept['success'] == 'true') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sukses membuat barang keluar!'),
                          ),
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/BarangKeluar',
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error' + sendAndAccept['message']!),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Dibatalkan..."),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Ada yang tidak tervalidasi, silahkan cek inputan untuk info lebih lanjut"),
                      ),
                    );
                  }
                },
                label: const Text("Submit"),
                icon: const Icon(FontAwesomeIcons.check),
              )
            : Container(),
        drawer: const Sidebar(),
        appBar: AppBar(
          title: const Text("SIIB | Tambah Barang Keluar"),
          backgroundColor: Colors.blue[400],
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  BarModForBarKel barModForBarKel =
                      BarModForBarKel(id: forms.length);
                  forms.add(BarangKeluarForm(
                    barModForBarKel: barModForBarKel,
                    onRemove: () => onRemove(barModForBarKel),
                    formkey: _formTambahBarangKeluarKey,
                  ));
                  print(forms.length);
                });
              },
              icon: const Icon(FontAwesomeIcons.plus),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 100.0),
            child: FormBuilder(
              key: _formTambahBarangKeluarKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const DividerWithNamed(
                            name: "Pilih Unit Kerja",
                            paddingLeft: 0.0,
                            paddingRight: 0.0,
                          ),
                          FutureBuilder(
                            future: unitKerja,
                            builder: (context,
                                AsyncSnapshot<List<UnitKerjaModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  List<DropdownMenuItem<int>> lists = [];
                                  for (var item in snapshot.data!) {
                                    lists.add(DropdownMenuItem(
                                      child: Text(item.namaUnitKerja),
                                      value: item.idUnitKerja,
                                    ));
                                  }
                                  return FormBuilderDropdown(
                                    name: "unitKerja",
                                    items: lists,
                                    validator: (value) => value == null
                                        ? 'Unit Kerja dibutuhkan'
                                        : null,
                                    decoration: const InputDecoration(
                                        labelText: "Unit Kerja"),
                                  );
                                } else {
                                  return const Text(
                                      "Gagal memuat Unit Kerja, silahkan muat ulang halaman ini");
                                }
                              } else {
                                return Center(
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
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  forms.isNotEmpty
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: forms.length,
                          itemBuilder: (context, idx) {
                            return forms[idx];
                          },
                        )
                      : Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 7.0),
                                  child: const Text("Tekan tombol"),
                                ),
                                const Icon(FontAwesomeIcons.plus),
                                Container(
                                  margin: const EdgeInsets.only(left: 7.0),
                                  child:
                                      const Text("untuk menambah item barang"),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onRemove(BarModForBarKel barModForBarKel) {
    setState(() {
      int idx = forms.indexWhere(
          (element) => element.barModForBarKel.id == barModForBarKel.id);
      if (forms.isNotEmpty) {
        _formTambahBarangKeluarKey.currentState!
            .removeInternalFieldValue("brng_$idx", isSetState: true);
        _formTambahBarangKeluarKey.currentState!
            .removeInternalFieldValue("qtyNow_$idx", isSetState: true);
        _formTambahBarangKeluarKey.currentState!
            .removeInternalFieldValue("satuan_$idx", isSetState: true);
        _formTambahBarangKeluarKey.currentState!
            .removeInternalFieldValue("kuantitas_$idx", isSetState: true);
        //   "brng_$idx": 0,
        //   "qtyNow_$idx": "0",
        //   "satuan_$idx": 0,
        //   "kuantitas_$idx": "0",
        // });
        forms.removeAt(idx);
      }
      print(forms.toString());
    });
  }
}
