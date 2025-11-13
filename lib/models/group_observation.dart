class GroupObservation {
  String SEGELV;
  String SEGANE;
  String SEGPER;
  String SEGCYC;
  String SEGNIV;
  String SEGCLS;
  String SEGGRP;
  double SEGMOYENNE;
  String SEGOBSERV;
  String SEGSPC;

  GroupObservation({
    this.SEGELV = '',
    this.SEGANE = '',
    this.SEGPER = '',
    this.SEGCYC = '',
    this.SEGNIV = '',
    this.SEGCLS = '',
    this.SEGGRP = '',
    this.SEGMOYENNE = 0.0,
    this.SEGOBSERV = '',
    this.SEGSPC = '',
  });

  factory GroupObservation.fromJson(Map<String, dynamic> json) {
    return GroupObservation(
      SEGELV: json['SEGELV'] ?? '',
      SEGANE: json['SEGANE'] ?? '',
      SEGPER: json['SEGPER'] ?? '',
      SEGCYC: json['SEGCYC'] ?? '',
      SEGNIV: json['SEGNIV'] ?? '',
      SEGCLS: json['SEGCLS'] ?? '',
      SEGGRP: json['SEGGRP'] ?? '',
      SEGMOYENNE: (json['SEGMOYENNE'] ?? 0.0).toDouble(),
      SEGOBSERV: json['SEGOBSERV'] ?? '',
      SEGSPC: json['SEGSPC'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SEGELV': SEGELV,
      'SEGANE': SEGANE,
      'SEGPER': SEGPER,
      'SEGCYC': SEGCYC,
      'SEGNIV': SEGNIV,
      'SEGCLS': SEGCLS,
      'SEGGRP': SEGGRP,
      'SEGMOYENNE': SEGMOYENNE,
      'SEGOBSERV': SEGOBSERV,
      'SEGSPC': SEGSPC,
    };
  }

  static List<GroupObservation> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => GroupObservation.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<GroupObservation> list) {
    return list.map((groupObservation) => groupObservation.toJson()).toList();
  }
}
