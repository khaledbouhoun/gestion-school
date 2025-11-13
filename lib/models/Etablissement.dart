class Etablissement {
  final String ETBNOM;
  final String ETBADR1;
  final String ETBADR2;
  final String ETBADR3;
  final String ETBADR4;
  final String ETBTEL1;
  final String ETBTEL2;
  final String ETBFAX;
  final String ETBEMAIL;
  final String ETBWEB;
  final String ETBNOAGREM;
  final String ETBANECOUR;
  final String ETBDIRNOM;
  final String ETBDIRPRENOM;
  final String ETBACADEMIE;
  final String ETBNOMABV;
  final double ETBTYPE;
  final String ETBLOGO;
  final String ETBAVIS;
  final String ETBANECOTCOUR;
  final String ETBNOCMMC;
  final DateTime ETBDATEAGREM;
  final DateTime ETBDATECMMC;

  Etablissement({
    required this.ETBNOM,
    required this.ETBADR1,
    required this.ETBADR2,
    required this.ETBADR3,
    required this.ETBADR4,
    required this.ETBTEL1,
    required this.ETBTEL2,
    required this.ETBFAX,
    required this.ETBEMAIL,
    required this.ETBWEB,
    required this.ETBNOAGREM,
    required this.ETBANECOUR,
    required this.ETBDIRNOM,
    required this.ETBDIRPRENOM,
    required this.ETBACADEMIE,
    required this.ETBNOMABV,
    required this.ETBTYPE,
    required this.ETBLOGO,
    required this.ETBAVIS,
    required this.ETBANECOTCOUR,
    required this.ETBNOCMMC,
    required this.ETBDATEAGREM,
    required this.ETBDATECMMC,
  });

  factory Etablissement.fromJson(Map<String, dynamic> json) {
    return Etablissement(
      ETBNOM: json['ETBNOM'] ?? '',
      ETBADR1: json['ETBADR1'] ?? '',
      ETBADR2: json['ETBADR2'] ?? '',
      ETBADR3: json['ETBADR3'] ?? '',
      ETBADR4: json['ETBADR4'] ?? '',
      ETBTEL1: json['ETBTEL1'] ?? '',
      ETBTEL2: json['ETBTEL2'] ?? '',
      ETBFAX: json['ETBFAX'] ?? '',
      ETBEMAIL: json['ETBEMAIL'] ?? '',
      ETBWEB: json['ETBWEB'] ?? '',
      ETBNOAGREM: json['ETBNOAGREM'] ?? '',
      ETBANECOUR: json['ETBANECOUR'] ?? '',
      ETBDIRNOM: json['ETBDIRNOM'] ?? '',
      ETBDIRPRENOM: json['ETBDIRPRENOM'] ?? '',
      ETBACADEMIE: json['ETBACADEMIE'] ?? '',
      ETBNOMABV: json['ETBNOMABV'] ?? '',
      ETBTYPE: (json['ETBTYPE'] is num) ? (json['ETBTYPE'] as num).toDouble() : double.tryParse(json['ETBTYPE'].toString()) ?? 0.0,
      ETBLOGO: json['ETBLOGO'] ?? '',
      ETBAVIS: json['ETBAVIS'] ?? '',
      ETBANECOTCOUR: json['ETBANECOTCOUR'] ?? '',
      ETBNOCMMC: json['ETBNOCMMC'] ?? '',
      ETBDATEAGREM: DateTime.tryParse(json['ETBDATEAGREM'] ?? '') ?? DateTime(1970, 1, 1),
      ETBDATECMMC: DateTime.tryParse(json['ETBDATECMMC'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ETBNOM': ETBNOM,
      'ETBADR1': ETBADR1,
      'ETBADR2': ETBADR2,
      'ETBADR3': ETBADR3,
      'ETBADR4': ETBADR4,
      'ETBTEL1': ETBTEL1,
      'ETBTEL2': ETBTEL2,
      'ETBFAX': ETBFAX,
      'ETBEMAIL': ETBEMAIL,
      'ETBWEB': ETBWEB,
      'ETBNOAGREM': ETBNOAGREM,
      'ETBANECOUR': ETBANECOUR,
      'ETBDIRNOM': ETBDIRNOM,
      'ETBDIRPRENOM': ETBDIRPRENOM,
      'ETBACADEMIE': ETBACADEMIE,
      'ETBNOMABV': ETBNOMABV,
      'ETBTYPE': ETBTYPE,
      'ETBLOGO': ETBLOGO,
      'ETBAVIS': ETBAVIS,
      'ETBANECOTCOUR': ETBANECOTCOUR,
      'ETBNOCMMC': ETBNOCMMC,
      'ETBDATEAGREM': ETBDATEAGREM.toIso8601String(),
      'ETBDATECMMC': ETBDATECMMC.toIso8601String(),
    };
  }

  static List<Etablissement> listFromJson(List<dynamic> json) {
    return json.map((e) => Etablissement.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Etablissement> etablissements) {
    return etablissements.map((e) => e.toJson()).toList();
  }
}
