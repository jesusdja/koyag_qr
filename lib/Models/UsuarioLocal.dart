class UsuarioLocal {
  int participantId;
  String firstname;
  String lastname;
  String fullname;
  String email;
  int accreditationStatus;
  int accretationHour;
  String uuid;
  String avatar;
  String position;
  String organization;

  UsuarioLocal(
      {
        this.participantId,
        this.firstname,
        this.lastname,
        this.fullname,
        this.email,
        this.accreditationStatus,
        this.accretationHour,
        this.uuid,
        this.avatar,
        this.organization,
        this.position
      });

  UsuarioLocal.fromJson(Map<String, dynamic> json) {
    participantId = json['participantId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    email = json['email'];
    accreditationStatus = json['accreditationStatus'];
    accretationHour = json['accretationHour'];
    uuid = json['uuid'];
    avatar = json['avatar'];
    organization = json['organization'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['participantId'] = this.participantId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['accreditationStatus'] = this.accreditationStatus;
    data['accretationHour'] = this.accretationHour;
    data['uuid'] = this.uuid;
    data['avatar'] = this.avatar;
    data['organization'] = this.organization;
    data['position'] = this.position;
    return data;
  }

  UsuarioLocal.fromMap(Map snapshot) :
        participantId = snapshot['participantId']== null ? 0 :snapshot['participantId'],
        firstname = snapshot['firstname']== null ? '' :snapshot['firstname'],
        lastname = snapshot['lastname']== null ? '' :snapshot['lastname'],
        fullname = snapshot['fullname']== null ? '' :snapshot['fullname'],
        email = snapshot['email']== null ? '' :snapshot['email'],
        accreditationStatus = snapshot['accreditationStatus']== null ? 0 :snapshot['accreditationStatus'],
        accretationHour = snapshot['accretationHour']== null ? 0 :snapshot['accretationHour'],
        uuid = snapshot['uuid']== null ? '' :snapshot['uuid'],
        avatar = snapshot['avatar']== null ? '' :snapshot['avatar'],
        organization = snapshot['organization']== null ? '' :snapshot['organization'],
        position = snapshot['position']== null ? '' :snapshot['position']

  ;

  UsuarioLocal.map(dynamic obj) {
    this.participantId = obj['participantId'];
    this.firstname = obj['firstname'];
    this.lastname = obj['lastname'];
    this.fullname = obj['fullname'];
    this.email = obj['email'];
    this.accreditationStatus = obj['accreditationStatus'];
    this.accretationHour = obj['accretationHour'];
    this.uuid = obj['uuid'];
    this.avatar = obj['avatar'];
    this.organization = obj['organization'];
    this.position = obj['position'];
  }

  Map<String, dynamic> toMap() => {
    'participantId' : participantId,
    'firstname' : firstname,
    'lastname' : lastname,
    'fullname' : fullname,
    'email' : email,
    'accreditationStatus' : accreditationStatus,
    'accretationHour' : accretationHour,
    'uuid' : uuid,
    'avatar' : avatar,
    'organization' : organization,
    'position' : position,

  };
}