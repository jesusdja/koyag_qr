class Usuario {
  int participantId;
  String firstname;
  String lastname;
  String fullname;
  String email;
  int accreditationStatus;
  int accreditation;

  Usuario(
      {this.participantId,
        this.firstname,
        this.lastname,
        this.fullname,
        this.email,
        this.accreditationStatus,
        this.accreditation});

  Usuario.fromJson(Map<String, dynamic> json) {
    participantId = json['participantId'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    fullname = json['fullname'];
    email = json['email'];
    accreditationStatus = json['accreditationStatus'];
    accreditation = json['accreditation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['participantId'] = this.participantId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['accreditationStatus'] = this.accreditationStatus;
    data['accreditation'] = this.accreditation;
    return data;
  }
}