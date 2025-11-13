import 'package:flutter/widgets.dart';

class Note {
  String? NOTELV;
  String NOTANE;
  String NOTCYC;
  String NOTNIV;
  String NOTMAT;
  String NOTPER;
  String NOTEVA;
  double? NOTVALEUR;
  String NOTSPC;
  String NOTCLS;
  String ELVNOM;
  String ELVPRENOM;
  // double SEMMOYENNE;
  String SEMOBSERV;
  TextEditingController? controller;
  bool isMessageError = false;

  Note({
    this.NOTELV,
    this.NOTANE = '',
    this.NOTCYC = '',
    this.NOTNIV = '',
    this.NOTMAT = '',
    this.NOTPER = '',
    this.NOTEVA = '',
    this.NOTVALEUR,
    this.NOTSPC = '',
    this.NOTCLS = '',
    this.ELVNOM = '',
    this.ELVPRENOM = '',
    this.SEMOBSERV = '',
    this.controller,
    this.isMessageError = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      NOTELV: json['NOTELV'] ?? '',
      NOTANE: json['NOTANE'] ?? '',
      NOTCYC: json['NOTCYC'] ?? '',
      NOTNIV: json['NOTNIV'] ?? '',
      NOTMAT: json['NOTMAT'] ?? '',
      NOTPER: json['NOTPER'] ?? '',
      NOTEVA: json['NOTEVA'] ?? '',
      NOTVALEUR: (json['NOTVALEUR'] as num?)?.toDouble(),
      NOTSPC: json['NOTSPC'] ?? '',
      NOTCLS: json['NOTCLS'] ?? '',
      ELVNOM: json['ELVNOM'] ?? '',
      ELVPRENOM: json['ELVPRENOM'] ?? '',
      // SEMMOYENNE: (json['SEMMOYENNE'] as num?)?.toDouble() ?? 0.0,
      SEMOBSERV: json['SEMOBSERV'] ?? '',
      controller: TextEditingController(text: (json['NOTVALEUR'] as num?)?.toString() ?? ''),
      isMessageError: false,
    );
  }

  static Note modified(Map<String, dynamic> json) {
    return Note(
      NOTELV: json['NOTELV'] ?? '',
      NOTANE: json['NOTANE'] ?? '',
      NOTCYC: json['NOTCYC'] ?? '',
      NOTNIV: json['NOTNIV'] ?? '',
      NOTMAT: json['NOTMAT'] ?? '',
      NOTPER: json['NOTPER'] ?? '',
      NOTEVA: json['NOTEVA'] ?? '',
      NOTVALEUR: (json['NOTVALEUR'] as num?)?.toDouble(),
      NOTSPC: json['NOTSPC'] ?? '',
      NOTCLS: json['NOTCLS'] ?? '',
      ELVNOM: json['ELVNOM'] ?? '',
      ELVPRENOM: json['ELVPRENOM'] ?? '',
      // SEMMOYENNE: (json['SEMMOYENNE'] as num?)?.toDouble() ?? 0.0,
      SEMOBSERV: json['SEMOBSERV'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NOTELV': NOTELV,
      'NOTANE': NOTANE,
      'NOTCYC': NOTCYC,
      'NOTNIV': NOTNIV,
      'NOTMAT': NOTMAT,
      'NOTPER': NOTPER,
      'NOTEVA': NOTEVA,
      'NOTVALEUR': NOTVALEUR,
      'NOTSPC': NOTSPC,
      'NOTCLS': NOTCLS,
      'ELVNOM': ELVNOM,
      'ELVPRENOM': ELVPRENOM,
      // 'SEMMOYENNE': SEMMOYENNE,
      'SEMOBSERV': SEMOBSERV,
    };
  }

  static List<Note> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Note.fromJson(json as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Note> notes) {
    return notes.map((note) => note.toJson()).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || // إذا نفس المرجع (نفس الكائن)
      other is Note && // لازم يكون Note
          runtimeType == other.runtimeType && // نفس النوع
          NOTELV == other.NOTELV; // نقارن حسب الـ ID

  @override
  int get hashCode => NOTELV.hashCode; // لازم يتماشى مع ==
}
