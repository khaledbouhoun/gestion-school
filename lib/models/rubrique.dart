class Rubrique {
  final String USBUSR;
  final String USBDOS;
  final String USBANE;
  final String USBCYC;
  final String USBNIV;
  final String USBSPC;
  final String USBCLS;
  final String USBTRB;
  final String USBRUB;
  final double USBETAT;

  Rubrique({
    required this.USBUSR,
    required this.USBDOS,
    required this.USBANE,
    required this.USBCYC,
    required this.USBNIV,
    required this.USBSPC,
    this.USBCLS = '',
    required this.USBTRB,
    required this.USBRUB,
    this.USBETAT = 0.0,
  });

  factory Rubrique.fromJson(Map<String, dynamic> json) {
    return Rubrique(
      USBUSR: json['USBUSR'] ?? '',
      USBDOS: json['USBDOS'] ?? '',
      USBANE: json['USBANE'] ?? '',
      USBCYC: json['USBCYC'] ?? '',
      USBNIV: json['USBNIV'] ?? '',
      USBSPC: json['USBSPC'] ?? '',
      USBCLS: json['USBCLS'] ?? '',
      USBTRB: json['USBTRB'] ?? '',
      USBRUB: json['USBRUB'] ?? '',
      USBETAT: (json['USBETAT'] is num)
    ? (json['USBETAT'] as num).toDouble()
    : double.tryParse(json['USBETAT'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'USBUSR': USBUSR,
      'USBDOS': USBDOS,
      'USBANE': USBANE,
      'USBCYC': USBCYC,
      'USBNIV': USBNIV,
      'USBSPC': USBSPC,
      'USBCLS': USBCLS,
      'USBTRB': USBTRB,
      'USBRUB': USBRUB,
      'USBETAT': USBETAT,
    };
  }

  static List<Rubrique> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Rubrique.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Rubrique> rubriqueList) {
    return rubriqueList.map((rubrique) => rubrique.toJson()).toList();
  }
}
