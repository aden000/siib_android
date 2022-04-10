class BarangKeluarModel {
  final int idBarangKeluar;
  final int idUnitKerja;
  final DateTime tanggalKeluar;
  final int status;

  BarangKeluarModel({
    required this.idBarangKeluar,
    required this.idUnitKerja,
    required this.tanggalKeluar,
    required this.status,
  });

  factory BarangKeluarModel.fromJson(Map<String, dynamic> json) {
    return BarangKeluarModel(
      idBarangKeluar: json['id_barang_keluar'],
      idUnitKerja: json['id_unit_kerja'],
      tanggalKeluar: json['tanggal_keluar'],
      status: json['status'],
    );
  }
}
