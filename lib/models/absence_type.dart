class AbsenceType {
  final String TABNO;
  final String TABNOM;

  AbsenceType({
    required this.TABNO,
    required this.TABNOM,
  });

  factory AbsenceType.fromJson(Map<String, dynamic> json) {
    return AbsenceType(
      TABNO: json['TABNO'] ?? '',
      TABNOM: json['TABNOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TABNO': TABNO,
      'TABNOM': TABNOM,
    };
  }

  static List<AbsenceType> listFromJson(List<dynamic> json) {
    return json.map((e) => AbsenceType.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<AbsenceType> types) {
    return types.map((type) => type.toJson()).toList();
  }
}
