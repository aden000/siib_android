class DetailBarangKeluarModel {
  final int idDetailBarangKeluar;
  final int idBarang;
  final String namaBarang;
  final int kuantitas;
  final String namaSatuan;

  DetailBarangKeluarModel({
    required this.idDetailBarangKeluar,
    required this.idBarang,
    required this.namaBarang,
    required this.kuantitas,
    required this.namaSatuan,
  });

  factory DetailBarangKeluarModel.fromJson(Map<String, dynamic> json) {
    return DetailBarangKeluarModel(
      idDetailBarangKeluar: int.parse(json['id_detail_barang_keluar']),
      idBarang: int.parse(json['id_barang']),
      namaBarang: json['nama_barang'],
      kuantitas: int.parse(json['kuantitas']),
      namaSatuan: json['nama_satuan'],
    );
  }
}
