class Discipline {
  String DEVANE;
  String? DEVELV;
  DateTime DEVDATE;
  String? DEVDEC;
  String DEVPFS;
  String DEVOBSERV;
  String? DEVPER;
  double DEVFNC;
  String ELVNOM;
  String ELVPRENOM;
  String DECNOM;
  String DECTYPE;

  Discipline({
    this.DEVANE = '',
    this.DEVELV,
    DateTime? DEVDATE,
    this.DEVDEC,
    this.DEVPFS = '',
    this.DEVOBSERV = '',
    this.DEVPER,
    this.DEVFNC = 0.0,
    this.ELVNOM = '',
    this.ELVPRENOM = '',
    this.DECNOM = '',
    this.DECTYPE = '',
  }) : DEVDATE = DEVDATE ?? DateTime(1970, 1, 1);

  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      DEVANE: json['devane'] ?? '',
      DEVELV: json['develv'],
      DEVDATE: json['devdate'] != null ? DateTime.parse(json['devdate']).add(Duration(hours: 1)) : DateTime(1970, 1, 1),
      DEVDEC: json['devdec'],
      DEVPFS: json['devpfs'] ?? '',
      DEVOBSERV: json['devobserv'] ?? '',
      DEVPER: json['devper'],
      DEVFNC: (json['devfnc'] is num) ? (json['devfnc'] as num).toDouble() : 0.0,
      ELVNOM: json['elvnom'] ?? '',
      ELVPRENOM: json['elvprenom'] ?? '',
      DECNOM: json['decnom'] ?? '',
      DECTYPE: json['dectype'] ?? '',
    );
  }

  static Discipline modified(Map<String, dynamic> json) {
    return Discipline(
      DEVANE: json['devane'] ?? '',
      DEVELV: json['develv'],
      DEVDATE: DateTime.parse(json['devdate']),
      DEVDEC: json['devdec'],
      DEVPFS: json['devpfs'] ?? '',
      DEVOBSERV: json['devobserv'] ?? '',
      DEVPER: json['devper'],
      DEVFNC: (json['devfnc'] ?? 0.0).toDouble(),
      ELVNOM: json['elvnom'] ?? '',
      ELVPRENOM: json['elvprenom'] ?? '',
      DECNOM: json['decnom'] ?? '',
      DECTYPE: json['dectype'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'devane': DEVANE,
      'develv': DEVELV,
      'devdate': DEVDATE.toIso8601String(),
      'devdec': DEVDEC,
      'devpfs': DEVPFS,
      'devobserv': DEVOBSERV,
      'devper': DEVPER,
      'devfnc': DEVFNC,
      'elvnom': ELVNOM,
      'elvprenom': ELVPRENOM,
      'decnom': DECNOM,
      'dectype': DECTYPE,
    };
  }

  static List<Discipline> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Discipline.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Discipline> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
