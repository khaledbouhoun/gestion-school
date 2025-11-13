class DisciplineType {
  String DECNO;
  String DECNOM;
  String DECTYPE;
  double DECNOTE;

  DisciplineType({
    this.DECNO = '',
    this.DECNOM = '',
    this.DECTYPE = '',
    this.DECNOTE = 0.0,
  });

  factory DisciplineType.fromJson(Map<String, dynamic> json) {
    return DisciplineType(
      DECNO: json['DECNO'] ?? '',
      DECNOM: json['DECNOM'] ?? '',
      DECTYPE: json['DECTYPE'] ?? '',
      DECNOTE: (json['DECNOTE'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DECNO': DECNO,
      'DECNOM': DECNOM,
      'DECTYPE': DECTYPE,
      'DECNOTE': DECNOTE,
    };
  }

  static List<DisciplineType> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => DisciplineType.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<DisciplineType> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
