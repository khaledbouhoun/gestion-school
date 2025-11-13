class Module {
  final String MATNO;
  final String MATNOM;

  Module({
    required this.MATNO,
    required this.MATNOM,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      MATNO: json['MATNO'] ?? '',
      MATNOM: json['MATNOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MATNO': MATNO,
      'MATNOM': MATNOM,
    };
  }

  static List<Module> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Module.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Module> Modules) {
    return Modules.map((Module) => Module.toJson()).toList();
  }
}
