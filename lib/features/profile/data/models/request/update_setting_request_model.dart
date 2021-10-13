class UpdateSettingsRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String birthday;
  final String instagram;
  final String ticTok;
  final String twitter;
  final String snapchat;
  final String level;
  final int monetization;
  final String aboutYou;
  final String website;
  final String schoolName;
  final String devisionConference;
  final String eduAwards;
  final String gpa;
  final String sports;
  final String city;
  final String stateProfile;
  final String serviceHours;
  final String awards;
  final String gender;
  final String username;
  final String countryId;

  UpdateSettingsRequestModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.instagram,
      this.ticTok,
      this.twitter,
      this.snapchat,
      this.birthday,
      this.level,
      this.monetization,
      this.aboutYou,
      this.website,
      this.schoolName,
      this.devisionConference,
      this.eduAwards,
      this.gpa,
      this.sports,
      this.city,
      this.stateProfile,
      this.serviceHours,
      this.awards,
      this.gender,
      this.username,
      this.countryId});

  Map<String, dynamic> toJson() => {
        // "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "birthday": birthday == null ? null : birthday,
        "instagram": instagram == null ? null : instagram,
        "tic_tok": ticTok == null ? null : ticTok,
        "twitter": twitter == null ? null : twitter,
        "snapchat": snapchat == null ? null : snapchat,
        "level": level == null ? null : level,
        "monetization": monetization == null ? null : monetization,
        // "is_verified": isVerified == null ? null : isVerified,
        "school_name": schoolName == null ? null : schoolName,
        "division_conference":
            devisionConference == null ? null : devisionConference,
        "edu_awards": eduAwards == null ? null : eduAwards,
        "gpa": gpa == null ? null : gpa,
        "sports": sports == null ? null : sports,
        "city": city == null ? null : city,
        "state": stateProfile == null ? null : stateProfile,
        "service_hours": serviceHours == null ? null : serviceHours,
        "awards": awards == null ? null : awards,
        "website": website == null ? null : website,
        "about": aboutYou == null ? null : aboutYou,
        "gender": gender == null ? null : gender,
        "country_id": countryId == null ? null : countryId,
      };
}
