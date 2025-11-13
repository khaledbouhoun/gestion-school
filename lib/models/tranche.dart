class Tranche {
  String TRCANE;
  String TRCCYC;
  String TRCNIV;
  String TRCCLS;
  String? TRCELV;
  String TRCSPC;
  String TRCPER;
  String? TRCDU;
  String? TRCAU;
  String TRCOBS;
  double TRCNBHIZEB;
  double? TRCSOURADE;
  double? TRCAYADE;
  double? TRCSOURAA;
  double? TRCAYAA;
  double TRCNBTHOMON;
  double? TRCSENS;
  String ELVNOM;
  String ELVPRENOM;

  Tranche({
    this.TRCANE = '',
    this.TRCCYC = '',
    this.TRCNIV = '',
    this.TRCCLS = '',
    this.TRCELV,
    this.TRCSPC = '',
    this.TRCPER = '',
    this.TRCDU,
    this.TRCAU,
    this.TRCOBS = '',
    this.TRCNBHIZEB = 0.0,
    this.TRCSOURADE,
    this.TRCAYADE,
    this.TRCSOURAA,
    this.TRCAYAA,
    this.TRCNBTHOMON = 0.0,
    this.TRCSENS,
    this.ELVNOM = '',
    this.ELVPRENOM = '',
  });

  factory Tranche.fromJson(Map<String, dynamic> json) {
    return Tranche(
      TRCANE: json['TRCANE'] ?? '',
      TRCCYC: json['TRCCYC'] ?? '',
      TRCNIV: json['TRCNIV'] ?? '',
      TRCCLS: json['TRCCLS'] ?? '',
      TRCELV: json['TRCELV'],
      TRCSPC: json['TRCSPC'] ?? '',
      TRCPER: json['TRCPER'] ?? '',
      TRCDU: json['TRCDU'],
      TRCAU: json['TRCAU'],
      TRCOBS: json['TRCOBS'] ?? '',
      TRCNBHIZEB: (json['TRCNBHIZEB'] ?? 0).toDouble(),
      TRCSOURADE: (json['TRCSOURADE'] ?? 0).toDouble(),
      TRCAYADE: (json['TRCAYADE'] ?? 0).toDouble(),
      TRCSOURAA: (json['TRCSOURAA'] ?? 0).toDouble(),
      TRCAYAA: (json['TRCAYAA'] ?? 0).toDouble(),
      TRCNBTHOMON: (json['TRCNBTHOMON'] ?? 0).toDouble(),
      TRCSENS: (json['TRCSENS'] ?? 1).toDouble(),
      ELVNOM: json['ELVNOM'] ?? '',
      ELVPRENOM: json['ELVPRENOM'] ?? '',
    );
  }

  static Tranche modified(Map<String, dynamic> json) {
    return Tranche(
      TRCANE: json['TRCANE'] ?? '',
      TRCCYC: json['TRCCYC'] ?? '',
      TRCNIV: json['TRCNIV'] ?? '',
      TRCCLS: json['TRCCLS'] ?? '',
      TRCELV: json['TRCELV'],
      TRCSPC: json['TRCSPC'] ?? '',
      TRCPER: json['TRCPER'] ?? '',
      TRCDU: json['TRCDU'],
      TRCAU: json['TRCAU'],
      TRCOBS: json['TRCOBS'] ?? '',
      TRCNBHIZEB: (json['TRCNBHIZEB'] ?? 0).toDouble(),
      TRCSOURADE: (json['TRCSOURADE'] ?? 0).toDouble(),
      TRCAYADE: (json['TRCAYADE'] ?? 0).toDouble(),
      TRCSOURAA: (json['TRCSOURAA'] ?? 0).toDouble(),
      TRCAYAA: (json['TRCAYAA'] ?? 0).toDouble(),
      TRCNBTHOMON: (json['TRCNBTHOMON'] ?? 0).toDouble(),
      TRCSENS: (json['TRCSENS'] ?? 1).toDouble(),
      ELVNOM: json['ELVNOM'] ?? '',
      ELVPRENOM: json['ELVPRENOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TRCANE': TRCANE,
      'TRCCYC': TRCCYC,
      'TRCNIV': TRCNIV,
      'TRCCLS': TRCCLS,
      'TRCELV': TRCELV,
      'TRCSPC': TRCSPC,
      'TRCPER': TRCPER,
      'TRCDU': TRCDU,
      'TRCAU': TRCAU,
      'TRCOBS': TRCOBS,
      'TRCNBHIZEB': TRCNBHIZEB,
      'TRCSOURADE': TRCSOURADE,
      'TRCAYADE': TRCAYADE,
      'TRCSOURAA': TRCSOURAA,
      'TRCAYAA': TRCAYAA,
      'TRCNBTHOMON': TRCNBTHOMON,
      'TRCSENS': TRCSENS,
      'ELVNOM': ELVNOM,
      'ELVPRENOM': ELVPRENOM,
    };
  }

  static List<Tranche> listFromJson(List<dynamic> json) {
    return json.map((e) => Tranche.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Tranche> tranches) {
    return tranches.map((e) => e.toJson()).toList();
  }
}
