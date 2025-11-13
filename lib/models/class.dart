class Class {
  final String CLSANE;
  final String CLSCYC;
  final String CLSNIV;
  final String CLSNO;
  final String CLSNOM;
  final String CLSPFS;
  final String CLSSPC;
  final double CLSORD;
  final String ANVANE;
  final String ANVCYC;
  final String ANVNIV;
  final double ANVMOYSUR;
  final double ANVMOYBREVET;
  final double ANVMOYPASSAGE;
  final double ANVDECISION;
  final double ANVKISTE;
  final double ANVMOYSUCCES;
  final double ANVMOYRACH;

  Class({
    this.CLSANE = '',
    this.CLSCYC = '',
    this.CLSNIV = '',
    this.CLSNO = '',
    this.CLSNOM = '',
    this.CLSPFS = '',
    required this.CLSSPC,
    this.CLSORD = 0.0,
    this.ANVANE = '',
    this.ANVCYC = '',
    this.ANVNIV = '',
    this.ANVMOYSUR = 0.0,
    this.ANVMOYBREVET = 0.0,
    this.ANVMOYPASSAGE = 0.0,
    this.ANVDECISION = 0.0,
    this.ANVKISTE = 0.0,
    this.ANVMOYSUCCES = 0.0,
    this.ANVMOYRACH = 0.0,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      CLSANE: json['CLSANE'] ?? '',
      CLSCYC: json['CLSCYC'] ?? '',
      CLSNIV: json['CLSNIV'] ?? '',
      CLSNO: json['CLSNO'] ?? '',
      CLSNOM: json['CLSNOM'] ?? '',
      CLSPFS: json['CLSPFS'] ?? '',
      CLSSPC: json['CLSSPC'] ?? '',
      CLSORD: (json['CLSORD'] is num) ? (json['CLSORD'] as num).toDouble() : double.tryParse(json['CLSORD'].toString()) ?? 0.0,
      ANVANE: json['ANVANE'] ?? '',
      ANVCYC: json['ANVCYC'] ?? '',
      ANVNIV: json['ANVNIV'] ?? '',
      ANVMOYSUR: (json['ANVMOYSUR'] is num) ? (json['ANVMOYSUR'] as num).toDouble() : double.tryParse(json['ANVMOYSUR'].toString()) ?? 0.0,
      ANVMOYBREVET: (json['ANVMOYBREVET'] is num)
          ? (json['ANVMOYBREVET'] as num).toDouble()
          : double.tryParse(json['ANVMOYBREVET'].toString()) ?? 0.0,
      ANVMOYPASSAGE: (json['ANVMOYPASSAGE'] is num)
          ? (json['ANVMOYPASSAGE'] as num).toDouble()
          : double.tryParse(json['ANVMOYPASSAGE'].toString()) ?? 0.0,
      ANVDECISION: (json['ANVDECISION'] is num)
          ? (json['ANVDECISION'] as num).toDouble()
          : double.tryParse(json['ANVDECISION'].toString()) ?? 0.0,
      ANVKISTE: (json['ANVKISTE'] is num) ? (json['ANVKISTE'] as num).toDouble() : double.tryParse(json['ANVKISTE'].toString()) ?? 0.0,
      ANVMOYSUCCES: (json['ANVMOYSUCCES'] is num)
          ? (json['ANVMOYSUCCES'] as num).toDouble()
          : double.tryParse(json['ANVMOYSUCCES'].toString()) ?? 0.0,
      ANVMOYRACH: (json['ANVMOYRACH'] is num)
          ? (json['ANVMOYRACH'] as num).toDouble()
          : double.tryParse(json['ANVMOYRACH'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CLSANE': CLSANE,
      'CLSCYC': CLSCYC,
      'CLSNIV': CLSNIV,
      'CLSNO': CLSNO,
      'CLSNOM': CLSNOM,
      'CLSPFS': CLSPFS,
      'CLSSPC': CLSSPC,
      'CLSORD': CLSORD,
      'ANVANE': ANVANE,
      'ANVCYC': ANVCYC,
      'ANVNIV': ANVNIV,
      'ANVMOYSUR': ANVMOYSUR,
      'ANVMOYBREVET': ANVMOYBREVET,
      'ANVMOYPASSAGE': ANVMOYPASSAGE,
      'ANVDECISION': ANVDECISION,
      'ANVKISTE': ANVKISTE,
      'ANVMOYSUCCES': ANVMOYSUCCES,
      'ANVMOYRACH': ANVMOYRACH,
    };
  }

  static Class copiedClass(Map<String, dynamic> json) {
    return Class(
      CLSANE: json['CLSANE'] ?? '',
      CLSCYC: json['CLSCYC'] ?? '',
      CLSNIV: json['CLSNIV'] ?? '',
      CLSNO: json['CLSNO'] ?? '',
      CLSNOM: json['CLSNOM'] ?? '',
      CLSPFS: json['CLSPFS'] ?? '',
      CLSSPC: json['CLSSPC'] ?? '',
      CLSORD: (json['CLSORD'] as num?)?.toDouble() ?? 0.0,
      ANVANE: json['ANVANE'] ?? '',
      ANVCYC: json['ANVCYC'] ?? '',
      ANVNIV: json['ANVNIV'] ?? '',
      ANVMOYSUR: (json['ANVMOYSUR'] as num?)?.toDouble() ?? 0.0,
      ANVMOYBREVET: (json['ANVMOYBREVET'] as num?)?.toDouble() ?? 0.0,
      ANVMOYPASSAGE: (json['ANVMOYPASSAGE'] as num?)?.toDouble() ?? 0.0,
      ANVDECISION: (json['ANVDECISION'] as num?)?.toDouble() ?? 0.0,
      ANVKISTE: (json['ANVKISTE'] as num?)?.toDouble() ?? 0.0,
      ANVMOYSUCCES: (json['ANVMOYSUCCES'] as num?)?.toDouble() ?? 0.0,
      ANVMOYRACH: (json['ANVMOYRACH'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static List<Class> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Class.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Class> models) {
    return models.map((model) => model.toJson()).toList();
  }
}
