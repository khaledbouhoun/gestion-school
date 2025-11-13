class Access {
  final String URSUSR;
  final String URSTRS;
  final String URSRES;
  final String URSDRO;
  final String URSDOS;

  Access({
    required this.URSUSR,
    required this.URSTRS,
    required this.URSRES,
    required this.URSDRO,
    required this.URSDOS,
  });

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      URSUSR: json['URSUSR'] ?? '',
      URSTRS: json['URSTRS'] ?? '',
      URSRES: json['URSRES'] ?? '',
      URSDRO: json['URSDRO'] ?? '',
      URSDOS: json['URSDOS'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'URSUSR': URSUSR,
      'URSTRS': URSTRS,
      'URSRES': URSRES,
      'URSDRO': URSDRO,
      'URSDOS': URSDOS,
    };
  }

  static List<Access> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Access.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Access> accessList) {
    return accessList.map((access) => access.toJson()).toList();
  }
}
