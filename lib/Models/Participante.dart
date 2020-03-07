class Participante {
  int uid;
  String fullname;
  String avatar;
  String mail;
  String position;
  String organization;
  int accreditation;
  String accretationHour;
  String u_uid;

  Participante(
      {this.uid,
        this.fullname,
        this.avatar,
        this.mail,
        this.position,
        this.organization,
        this.accreditation,
        this.accretationHour,
        this.u_uid});

  Participante.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] == null ? 0 : json['uid'];
    fullname = json['fullname'] == null ? '' : json['fullname'];
    avatar = json['avatar'] == null ? '' : json['avatar'];
    mail = json['mail']== null ? '' : json['mail'];
    position = json['position']== null ? '' :json['position'];
    organization = json['organization']== null ? '' :json['organization'];
    accreditation = json['accreditation'] == null ? 0 : json['accreditation'];
    accretationHour = json['accretationHour']== null ? '' :json['accretationHour'];
    u_uid = json['u_uid']== null ? '' : json['u_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['fullname'] = this.fullname;
    data['avatar'] = this.avatar;
    data['mail'] = this.mail;
    data['position'] = this.position;
    data['organization'] = this.organization;
    data['accreditation'] = this.accreditation;
    data['accretationHour'] = this.accretationHour;
    data['u_uid'] = this.u_uid;
    return data;
  }
}