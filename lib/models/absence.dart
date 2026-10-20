class Absence {
  String? EABELV;
  String? EABANE;
  String? EABPER;
  DateTime? EABDATE;
  double EABDUREE;
  String EABTYPE;
  String EABJUSTIF;
  String ELVNOM;
  String ELVPRENOM;
  String? ELVtel1;
  String? ELVtel2;
  String? AFFCLS;
  double? ELVSEXE;

  Absence({
    this.EABELV,
    this.EABANE,
    this.EABPER,
    this.EABDATE,
    this.EABDUREE = 0.0,
    this.EABTYPE = '01',
    this.EABJUSTIF = '',
    this.ELVNOM = '',
    this.ELVPRENOM = '',
    this.AFFCLS,
    this.ELVtel1,
    this.ELVtel2,

    this.ELVSEXE = 0,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      EABELV: json['eabelv'] as String? ?? '',
      EABANE: json['eabane'] as String? ?? '',
      EABPER: json['eabper'] as String? ?? '',
      EABDATE: DateTime.parse(json['eabdate'] as String? ?? '1970-01-01T00:00:00'),
      EABDUREE: (json['eabduree'] as num?)?.toDouble() ?? 0.0,
      EABTYPE: json['eabtype'] as String? ?? '',
      EABJUSTIF: json['eabjustif'] as String? ?? '',
      ELVNOM: json['elvnom'] as String? ?? '',
      ELVPRENOM: json['elvprenom'] as String? ?? '',
      ELVtel1: json['elvtel1'] as String? ?? '',
      ELVtel2: json['elvtel2'] as String? ?? '',
      AFFCLS: json['affcls'] as String? ?? '',
      ELVSEXE: (json['elvsexe'] as num?)?.toDouble() ?? 0,
    );
  }

  static Absence modified(Map<String, dynamic> json) {
    return Absence(
      EABELV: json['EABELV'] as String? ?? '',
      EABANE: json['EABANE'] as String? ?? '',
      EABPER: json['EABPER'] as String? ?? '',
      EABDATE: DateTime.parse(json['EABDATE'] as String? ?? '1970-01-01T00:00:00'),
      EABDUREE: (json['EABDUREE'] as num?)?.toDouble() ?? 0.0,
      EABTYPE: json['EABTYPE'] as String? ?? '',
      EABJUSTIF: json['EABJUSTIF'] as String? ?? '',
      ELVNOM: json['ELVNOM'] as String? ?? '',
      ELVPRENOM: json['ELVPRENOM'] as String? ?? '',
      ELVtel1: json['ELVtel1'] as String? ?? '',
      ELVtel2: json['ELVtel2'] as String? ?? '',
      AFFCLS: json['AFFCLS'] as String? ?? '',
      ELVSEXE: (json['ELVSEXE'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EABELV': EABELV,
      'EABANE': EABANE,
      'EABPER': EABPER,
      'EABDATE': EABDATE?.toIso8601String(),
      'EABDUREE': EABDUREE,
      'EABTYPE': EABTYPE,
      'EABJUSTIF': EABJUSTIF,
      'ELVNOM': ELVNOM,
      'ELVPRENOM': ELVPRENOM,
      'ELVtel1': ELVtel1,
      'ELVtel2': ELVtel2,
      'AFFCLS': AFFCLS,
      'ELVSEXE': ELVSEXE,
    };
  }

  static List<Absence> listFromJson(List<dynamic> json) {
    return json.map((e) => Absence.fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Absence> data) {
    return data.map((e) => e.toJson()).toList();
  }
}
