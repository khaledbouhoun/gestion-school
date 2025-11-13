class SchoolYear {
  final String ANENO;
  final double ANEDEB;
  final double ANEFIN;
  final double ANEDEBH;
  final double ANEFINH;
  final DateTime? ANEDATEDEB;
  final DateTime? ANEDATEFIN;
  final double ANECLOSE;
  final double ANECOTCLOSE;

  SchoolYear({
    required this.ANENO,
    this.ANEDEB = 0.0,
    this.ANEFIN = 0.0,
    this.ANEDEBH = 0.0,
    this.ANEFINH = 0.0,
    this.ANEDATEDEB,
    this.ANEDATEFIN,
    this.ANECLOSE = 0.0,
    this.ANECOTCLOSE = 0.0,
  });

  factory SchoolYear.fromJson(Map<String, dynamic> json) {
    return SchoolYear(
      ANENO: json['ANENO'] ?? '',
      ANEDEB: (json['ANEDEB'] as num?)?.toDouble() ?? 0.0,
      ANEFIN: (json['ANEFIN'] as num?)?.toDouble() ?? 0.0,
      ANEDEBH: (json['ANEDEBH'] as num?)?.toDouble() ?? 0.0,
      ANEFINH: (json['ANEFINH'] as num?)?.toDouble() ?? 0.0,
      ANEDATEDEB: json['ANEDATEDEB'] != null ? DateTime.parse(json['ANEDATEDEB']).add(Duration(hours: 3)) : null,
      ANEDATEFIN: json['ANEDATEFIN'] != null ? DateTime.parse(json['ANEDATEFIN']).add(Duration(hours: 3)) : null,
      ANECLOSE: (json['ANECLOSE'] as num?)?.toDouble() ?? 0.0,
      ANECOTCLOSE: (json['ANECOTCLOSE'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ANENO': ANENO,
      'ANEDEB': ANEDEB,
      'ANEFIN': ANEFIN,
      'ANEDEBH': ANEDEBH,
      'ANEFINH': ANEFINH,
      'ANEDATEDEB': ANEDATEDEB?.toIso8601String(),
      'ANEDATEFIN': ANEDATEFIN?.toIso8601String(),
      'ANECLOSE': ANECLOSE,
      'ANECOTCLOSE': ANECOTCLOSE,
    };
  }

  static List<SchoolYear> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => SchoolYear.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<SchoolYear> schoolYears) {
    return schoolYears.map((schoolYear) => schoolYear.toJson()).toList();
  }
}
