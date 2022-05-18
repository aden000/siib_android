class UnitKerjaModel {
  final int idUnitKerja;
  final String namaUnitKerja;

  UnitKerjaModel({
    required this.idUnitKerja,
    required this.namaUnitKerja,
  });

  factory UnitKerjaModel.fromJson(Map<String, dynamic> json) {
    return UnitKerjaModel(
      idUnitKerja: int.parse(json['id_unit_kerja']),
      namaUnitKerja: json['nama_unit_kerja'],
    );
  }
}
