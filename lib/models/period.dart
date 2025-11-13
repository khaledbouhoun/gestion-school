class Period {
  String PERNO;
  String PERNOM;
  String ANPANE;
  String ANPPER;
  double ANPCLOSE;
  DateTime ANPDEB;
  DateTime ANPFIN;

  Period({
    this.PERNO = '',
    this.PERNOM = '',
    this.ANPANE = '',
    this.ANPPER = '',
    this.ANPCLOSE = 0.0,
    required this.ANPDEB,
    required this.ANPFIN,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      PERNO: json['PERNO'] ?? '',
      PERNOM: json['PERNOM'] ?? '',
      ANPANE: json['ANPANE'] ?? '',
      ANPPER: json['ANPPER'] ?? '',
      ANPCLOSE: (json['ANPCLOSE'] as num?)?.toDouble() ?? 0.0,
      ANPDEB: DateTime.parse(json['ANPDEB'] as String? ?? '1970-01-01').add(Duration(hours: 3)),
      ANPFIN: DateTime.parse(json['ANPFIN'] as String? ?? '1970-01-01').add(Duration(hours: 3)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PERNO': PERNO,
      'PERNOM': PERNOM,
      'ANPANE': ANPANE,
      'ANPPER': ANPPER,
      'ANPCLOSE': ANPCLOSE,
      'ANPDEB': ANPDEB.toIso8601String(),
      'ANPFIN': ANPFIN.toIso8601String(),
    };
  }

  static Period copiedPeriod(Map<String, dynamic> json){
    return Period(
      PERNO: json['PERNO'] ?? '',
      PERNOM: json['PERNOM'] ?? '',
      ANPANE: json['ANPANE'] ?? '',
      ANPPER: json['ANPPER'] ?? '',
      ANPCLOSE: (json['ANPCLOSE'] as num?)?.toDouble() ?? 0.0,
      ANPDEB: DateTime.parse(json['ANPDEB'] as String? ?? '1970-01-01').add(Duration(hours: 3)),
      ANPFIN: DateTime.parse(json['ANPFIN'] as String? ?? '1970-01-01').add(Duration(hours: 3)),
    );
  }

  static List<Period> listFromJson(List<dynamic> json) {
    return json.map((e) => Period.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Period> periods) {
    return periods.map((period) => period.toJson()).toList();
  }
}
