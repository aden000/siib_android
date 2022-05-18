class SatuanModel {
  final int idSatuan;
  final String namaSatuan;
  final int kuantitasSaatIni;

  SatuanModel({
    required this.idSatuan,
    required this.namaSatuan,
    required this.kuantitasSaatIni,
  });

  factory SatuanModel.fromJson(Map<String, dynamic> json) {
    return SatuanModel(
      idSatuan: int.parse(json['id_satuan']),
      namaSatuan: json['nama_satuan'],
      kuantitasSaatIni: int.parse(json['kuantitas']),
    );
  }
}
