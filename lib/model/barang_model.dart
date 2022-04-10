class BarangModel {
  final int idBarang;
  final int idKategoriBarang;
  final String namaBarang;
  final String namaKategoriBarang;

  BarangModel({
    required this.idBarang,
    required this.idKategoriBarang,
    required this.namaBarang,
    required this.namaKategoriBarang,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      idBarang: json['id_barang'],
      idKategoriBarang: json['id_kategori_barang'],
      namaBarang: json['nama_barang'],
      namaKategoriBarang: json['nama_kategori_barang'],
    );
  }
}
