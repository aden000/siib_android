class DetailBarangModel {
  final int idDetailBarang;
  final int idBarang;
  final String namaBarang;
  final String namaSatuan;
  final int kuantitas;
  final String namaTurunanSatuan;
  final int konversiTurunan;

  DetailBarangModel({
    required this.idDetailBarang,
    required this.idBarang,
    required this.namaBarang,
    required this.namaSatuan,
    required this.kuantitas,
    required this.namaTurunanSatuan,
    required this.konversiTurunan,
  });

  factory DetailBarangModel.fromJson(Map<String, dynamic> json) {
    return DetailBarangModel(
      idDetailBarang: int.parse(json['id_detail_barang']),
      idBarang: int.parse(json['id_barang']),
      namaBarang: json['nama_barang'],
      namaSatuan: json['nama_satuan'],
      kuantitas: int.parse(json['kuantitas']),
      namaTurunanSatuan: json['nama_turunan_satuan'],
      konversiTurunan: int.parse(json['konversi_turunan']),
    );
  }
}
