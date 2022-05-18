class DetailBarangModel {
  final int idDetailBarang;
  final int idBarang;
  final String namaBarang;
  final int idSatuan;
  final String namaSatuan;
  final int kuantitas;
  final String namaTurunanSatuan;
  final int konversiTurunan;

  DetailBarangModel({
    required this.idDetailBarang,
    required this.idBarang,
    required this.namaBarang,
    required this.idSatuan,
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
      idSatuan: int.parse(json['id_satuan']),
      namaSatuan: json['nama_satuan'],
      kuantitas: int.parse(json['kuantitas']),
      namaTurunanSatuan: json['nama_turunan_satuan'] ?? 'Tidak ada turunan',
      konversiTurunan: int.parse(json['konversi_turunan']),
    );
  }
}
