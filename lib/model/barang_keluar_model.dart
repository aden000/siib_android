class BarangKeluarModel {
  final int idBarangKeluar;
  final String namaUnitKerja;
  final String namaUser;
  final DateTime tanggalKeluar;
  final int status;

  BarangKeluarModel({
    required this.idBarangKeluar,
    required this.namaUnitKerja,
    required this.namaUser,
    required this.tanggalKeluar,
    required this.status,
  });

  factory BarangKeluarModel.fromJson(Map<String, dynamic> json) {
    return BarangKeluarModel(
      idBarangKeluar: int.parse(json['id_barang_keluar']),
      namaUnitKerja: json['nama_unit_kerja'],
      namaUser: json['nama_user'],
      tanggalKeluar: DateTime.parse(json['tanggal_keluar']),
      status: int.parse(json['status']),
    );
  }
}
