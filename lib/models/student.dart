class Student {
  String? elvno;
  String? elvnom;
  String? elvprenom;
  String? elvprenpere;
  String? elvprengrpere;
  DateTime? elvdatensc;
  String? elvlieunsc;
  String? elvtel1;
  String? elvtel2;
  String? sexe;
  String? elvadr1;
  String? ltrnom;
  String? elvsexe;

  Student({
    this.elvno,
    this.elvnom,
    this.elvprenom,
    this.elvprenpere,
    this.elvprengrpere,
    this.elvdatensc,
    this.elvlieunsc,
    this.elvtel1,
    this.elvtel2,
    this.sexe,
    this.elvadr1,
    this.ltrnom,
    this.elvsexe,
  });

  Student.fromJson(Map<String, dynamic> json) {
    elvno = json['elvno'];
    elvnom = json['elvnom'];
    elvprenom = json['elvprenom'];
    elvprenpere = json['elvprenpere'];
    elvprengrpere = json['elvprengrpere'];
    elvdatensc = json['elvdatensc'] != null ? DateTime.parse(json['elvdatensc']) : null;
    elvtel1 = json['elvtel1'];
    elvtel2 = json['elvtel2'];
    elvlieunsc = json['elvlieunsc'];
    sexe = json['sexe'];
    elvadr1 = json['elvadr1'];
    ltrnom = json['ltrnom'];
    elvsexe = json['elvsexe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['elvno'] = elvno;
    data['elvnom'] = elvnom;
    data['elvprenom'] = elvprenom;
    data['elvprenpere'] = elvprenpere;
    data['elvprengrpere'] = elvprengrpere;
    data['elvdatensc'] = elvdatensc;
    data['elvlieunsc'] = elvlieunsc;
    data['sexe'] = sexe;
    data['elvadr1'] = elvadr1;
    data['ltrnom'] = ltrnom;
    data['elvsexe'] = elvsexe;
    return data;
  }

  static List<Student> listFromJson(List<dynamic> json) {
    return json.map((e) => Student.fromJson(e)).toList();
  }
}
