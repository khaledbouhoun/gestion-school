class User {
  final String USRNOM;
  final String USRPRENOM;
  final String USRLOGIN;
  String USRPASSW;
  final String USRDOS;
  final double USRTYPE;
  final double USRETAT;
  final double USRCON;
  final DateTime? USRCONLEA;
  final DateTime? USRDECONLEA;
  final String USRNO;

  User({
    required this.USRNOM,
    required this.USRPRENOM,
    required this.USRLOGIN,
    this.USRPASSW = '',
    this.USRDOS = '',
    this.USRTYPE = 0.0,
    this.USRETAT = 0.0,
    this.USRCON = 0.0,
    this.USRCONLEA,
    this.USRDECONLEA,
    this.USRNO = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      USRNOM: json['USRNOM'] ?? '',
      USRPRENOM: json['USRPRENOM'] ?? '',
      USRLOGIN: json['USRLOGIN'] ?? '',
      USRPASSW: json['USRPASSW'] ?? '',
      USRDOS: json['USRDOS'] ?? '',
      USRTYPE: (json['USRTYPE'] as num?)?.toDouble() ?? 0.0,
      USRETAT: (json['USRETAT'] as num?)?.toDouble() ?? 0.0,
      USRCON: (json['USRCON'] is num) ? (json['USRCON'] as num).toDouble() : double.tryParse(json['USRCON'].toString()) ?? 0.0,
      USRCONLEA: (json['USRCONLEA'] != null && json['USRCONLEA'].toString().isNotEmpty)
          ? DateTime.parse(json['USRCONLEA']).add(Duration(hours: 3))
          : null,
      USRDECONLEA: (json['USRDECONLEA'] != null && json['USRDECONLEA'].toString().isNotEmpty)
          ? DateTime.parse(json['USRDECONLEA']).add(Duration(hours: 3))
          : null,
      USRNO: json['USRNO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'USRNOM': USRNOM,
      'USRPRENOM': USRPRENOM,
      'USRLOGIN': USRLOGIN,
      'USRPASSW': USRPASSW,
      'USRDOS': USRDOS,
      'USRTYPE': USRTYPE,
      'USRETAT': USRETAT,
      'USRCON': USRCON,
      'USRCONLEA': USRCONLEA?.toIso8601String(),
      'USRDECONLEA': USRDECONLEA?.toIso8601String(),
      'USRNO': USRNO,
    };
  }

  static List<User> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<User> users) {
    return users.map((user) => user.toJson()).toList();
  }
}
