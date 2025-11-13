class Evaluation {
  final String EVANO;
  final String EVANOM;
  final double EVATYPE;
  final String CREANE;
  final String CRECYC;
  final String CRENIV;
  final String CREMAT;
  final String CREEVA;
  final double CRECOEF;
  final double CRENOTSUR;
  final String CRESPC;
  final double CREORD;

  Evaluation({
    required this.EVANO,
    this.EVANOM = '',
    this.EVATYPE = 0.0,
    required this.CREANE,
    required this.CRECYC,
    required this.CRENIV,
    required this.CREMAT,
    required this.CREEVA,
    this.CRECOEF = 0.0,
    this.CRENOTSUR = 0.0,
    required this.CRESPC,
    this.CREORD = 0.0,
  });

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      EVANO: json['EVANO'] ?? '',
      EVANOM: json['EVANOM'] ?? '',
      EVATYPE: (json['EVATYPE'] as num?)?.toDouble() ?? 0.0,
      CREANE: json['CREANE'] ?? '',
      CRECYC: json['CRECYC'] ?? '',
      CRENIV: json['CRENIV'] ?? '',
      CREMAT: json['CREMAT'] ?? '',
      CREEVA: json['CREEVA'] ?? '',
      CRECOEF: (json['CRECOEF'] as num?)?.toDouble() ?? 0.0,
      CRENOTSUR: (json['CRENOTSUR'] as num?)?.toDouble() ?? 0.0,
      CRESPC: json['CRESPC'] ?? '',
      CREORD: (json['CREORD'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EVANO': EVANO,
      'EVANOM': EVANOM,
      'EVATYPE': EVATYPE,
      'CREANE': CREANE,
      'CRECYC': CRECYC,
      'CRENIV': CRENIV,
      'CREMAT': CREMAT,
      'CREEVA': CREEVA,
      'CRECOEF': CRECOEF,
      'CRENOTSUR': CRENOTSUR,
      'CRESPC': CRESPC,
      'CREORD': CREORD,
    };
  }

  static List<Evaluation> listFromJson(List<dynamic> json) {
    return json.map((e) => Evaluation.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Evaluation> data) {
    return data.map((e) => e.toJson()).toList();
  }
}
