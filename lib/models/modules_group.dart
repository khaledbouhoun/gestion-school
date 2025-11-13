class ModulesGroup {
  final String GRPNO;
  final String GRPNOM;
  final String NGPANE;
  final String NGPCYC;
  final String NGPNIV;
  final String NGPGRP;
  final double NGPORD;
  final String NGPSPC;

  ModulesGroup({
    required this.GRPNO,
    required this.GRPNOM,
    required this.NGPANE,
    required this.NGPCYC,
    required this.NGPNIV,
    required this.NGPGRP,
    required this.NGPORD,
    required this.NGPSPC,
  });

  factory ModulesGroup.fromJson(Map<String, dynamic> json) {
    return ModulesGroup(
      GRPNO: json['GRPNO'] ?? '',
      GRPNOM: json['GRPNOM'] ?? '',
      NGPANE: json['NGPANE'] ?? '',
      NGPCYC: json['NGPCYC'] ?? '',
      NGPNIV: json['NGPNIV'] ?? '',
      NGPGRP: json['NGPGRP'] ?? '',
      NGPORD: (json['NGPORD'] ?? 0.0).toDouble(),
      NGPSPC: json['NGPSPC'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GRPNO': GRPNO,
      'GRPNOM': GRPNOM,
      'NGPANE': NGPANE,
      'NGPCYC': NGPCYC,
      'NGPNIV': NGPNIV,
      'NGPGRP': NGPGRP,
      'NGPORD': NGPORD,
      'NGPSPC': NGPSPC,
    };
  }

  static List<ModulesGroup> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ModulesGroup.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<ModulesGroup> list) {
    return list.map((moduleGroup) => moduleGroup.toJson()).toList();
  }
}
