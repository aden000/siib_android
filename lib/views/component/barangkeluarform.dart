import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:siib_android/connection/connection.dart';
import 'package:siib_android/model/barang_model.dart';
import 'package:siib_android/model/barang_model_for_barkel.dart';
import 'package:siib_android/model/satuan_model.dart';
import 'package:siib_android/views/template/divider_withnamed.dart';

class BarangKeluarForm extends StatefulWidget {
  final BarModForBarKel barModForBarKel;
  final Function onRemove;
  final GlobalKey<FormBuilderState> formkey;
  const BarangKeluarForm({
    Key? key,
    required this.barModForBarKel,
    required this.onRemove,
    required this.formkey,
  }) : super(key: key);

  @override
  State<BarangKeluarForm> createState() => _BarangKeluarFormState();
}

class _BarangKeluarFormState extends State<BarangKeluarForm> {
  late Future<List<BarangModel>> barMod;
  @override
  void initState() {
    super.initState();
    barMod = getDataBarang(context);
  }

  final List<SatuanModel> _internalSatuanList = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DividerWithNamed(
                    name: "Item ${widget.barModForBarKel.id}",
                    paddingLeft: 0.0,
                    paddingRight: 5.0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onRemove.call();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        size: 15.0,
                      ),
                      Text("Hapus")
                    ],
                  ),
                )
              ],
            ),
            FutureBuilder(
              future: barMod,
              builder: (context, AsyncSnapshot<List<BarangModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<DropdownMenuItem<int>> lists = [];
                    for (var item in snapshot.data!) {
                      lists.add(DropdownMenuItem(
                        child: Text(item.namaBarang),
                        value: item.idBarang,
                      ));
                    }
                    return FormBuilderDropdown<int>(
                      name: "brng_${widget.barModForBarKel.id}",
                      items: lists,
                      validator: (value) =>
                          value == null ? 'Barang dibutuhkan' : null,
                      decoration:
                          const InputDecoration(labelText: "Pilih Barang"),
                      onChanged: (value) {
                        setState(() {
                          widget.barModForBarKel.idBarang = value ?? 0;
                          widget.formkey.currentState!.removeInternalFieldValue(
                              "satuan_${widget.barModForBarKel.id}",
                              isSetState: true);
                          widget.formkey.currentState!.removeInternalFieldValue(
                              "kuantitas_${widget.barModForBarKel.id}",
                              isSetState: true);
                          _internalSatuanList.clear();
                        });
                        widget.formkey.currentState!.patchValue({
                          "qtyNow_${widget.barModForBarKel.id}": "",
                        });
                      },
                      hint: const Text(
                        "Pilih barang",
                      ),
                    );
                  } else {
                    return const Text(
                      "Tidak mendapat data barang, cobalah memuat ulang halaman",
                    );
                  }
                } else {
                  return Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator.adaptive(),
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
            widget.barModForBarKel.idBarang != 0
                ? Row(
                    children: [
                      Flexible(
                        child: FutureBuilder(
                          future: getDataSatuanByIdBarang(
                              context, widget.barModForBarKel.idBarang),
                          builder: (context,
                              AsyncSnapshot<List<SatuanModel>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                List<DropdownMenuItem<int>> lists =
                                    List.empty(growable: true);
                                _internalSatuanList.clear();
                                _internalSatuanList.addAll(snapshot.data!);
                                for (var item in snapshot.data!) {
                                  lists.add(DropdownMenuItem(
                                    child: Text(item.namaSatuan),
                                    value: item.idSatuan,
                                  ));
                                }
                                return FormBuilderDropdown<int>(
                                  name: "satuan_${widget.barModForBarKel.id}",
                                  items: lists,
                                  decoration: const InputDecoration(
                                      labelText: "Pilih Satuan"),
                                  validator: (value) => value == null
                                      ? "Satuan diperlukan"
                                      : null,
                                  onChanged: (value) {
                                    // setState(() {
                                    widget.barModForBarKel.idSatuan =
                                        value ?? 0;
                                    // });
                                    setState(() {
                                      // if (_internalSatuanList is! List) {
                                      // _internalSatuanList =
                                      //     List.empty(growable: true);
                                      // }
                                      int idx = _internalSatuanList.indexWhere(
                                          (element) =>
                                              element.idSatuan == value);

                                      widget.formkey.currentState!.patchValue({
                                        "qtyNow_${widget.barModForBarKel.id}":
                                            _internalSatuanList[idx]
                                                .kuantitasSaatIni
                                                .toString()
                                      });
                                    });
                                  },
                                );
                              } else {
                                // setState(() {
                                _internalSatuanList.clear();
                                // });
                                return const Text(
                                  "Barang ini tidak mempunyai satuan",
                                );
                              }
                            } else {
                              return Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator.adaptive(),
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
                      const SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                        child: FormBuilderTextField(
                          enabled: false,
                          name: "qtyNow_${widget.barModForBarKel.id}",
                          decoration: const InputDecoration(
                              labelText: "Kuantitas Saat Ini"),
                        ),
                      )
                    ],
                  )
                : const Text(
                    "Harap pilih barang untuk munculkan satuan",
                  ),
            _internalSatuanList.isNotEmpty
                ? FormBuilderTextField(
                    // autovalidateMode: AutovalidateMode.always,
                    name: "kuantitas_${widget.barModForBarKel.id}",
                    decoration: const InputDecoration(
                      labelText: "Kuantitas",
                    ),
                    keyboardType: const TextInputType.numberWithOptions(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: "Harus diisi"),
                      FormBuilderValidators.max(
                          int.tryParse(widget.formkey.currentState!.getRawValue(
                                      "qtyNow_${widget.barModForBarKel.id}") ??
                                  "0") ??
                              0,
                          errorText:
                              "Tidak boleh melebihi ${int.tryParse(widget.formkey.currentState!.getRawValue("qtyNow_${widget.barModForBarKel.id}") ?? "0") ?? 0}"),
                      FormBuilderValidators.min(1,
                          errorText: "Setidaknya harus mengisi minimal 1"),
                    ]),
                    onChanged: (value) {
                      if (value!.isNotEmpty) {
                        widget.barModForBarKel.kuantitas = int.parse(value);
                      }
                    },
                  )
                : const Center(
                    child: Text(
                      "Menunggu untuk memilih satuan",
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
