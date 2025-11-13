class Folder {
  final String DOSNO;
  final String DOSNOM;
  final String DOSEXE;
  final String DOSBDD;
  final double DOSETAT;
  final String DOSBDDGEST;

  Folder({
    required this.DOSNO,
    required this.DOSNOM,
    required this.DOSEXE,
    required this.DOSBDD,
    this.DOSETAT = 0.0,
    required this.DOSBDDGEST,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      DOSNO: json['DOSNO'] ?? '',
      DOSNOM: json['DOSNOM'] ?? '',
      DOSEXE: json['DOSEXE'] ?? '',
      DOSBDD: json['DOSBDD'] ?? '',
      DOSETAT: (json['DOSETAT'] as num?)?.toDouble() ?? 0.0,
      DOSBDDGEST: json['DOSBDDGEST'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOSNO': DOSNO,
      'DOSNOM': DOSNOM,
      'DOSEXE': DOSEXE,
      'DOSBDD': DOSBDD,
      'DOSETAT': DOSETAT,
      'DOSBDDGEST': DOSBDDGEST,
    };
  }

  static List<Folder> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Folder.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Folder> folders) {
    return folders.map((folder) => folder.toJson()).toList();
  }
}
