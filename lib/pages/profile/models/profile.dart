class Profile {
  final String fullName;
  final String gender;
  final String dob;
  final String phoneNumber;
  final String addressLine;
  final String addressLine2;
  final String avatar;
  final String parentEmail;
  final String school;
  final String clazz;

  const Profile({
    required this.fullName,
    required this.gender,
    required this.dob,
    required this.phoneNumber,
    this.addressLine = "",
    this.addressLine2 = "",
    this.avatar = "",
    this.parentEmail = "",
    this.school = "",
    this.clazz = "",
  });

  static Profile get emptyProfile{
    return const Profile(
      fullName: "",
      gender: "",
      dob: "",
      phoneNumber: "",
    );
  }

  Map<String, String> get getJSON {
    final Map<String, String> dataProfile = {};
    dataProfile["full_name"] = fullName;
    dataProfile["phone_number"] = phoneNumber;
    dataProfile["dob"] = dob;
    dataProfile["gender"] = gender;
    dataProfile["school"] = school;
    dataProfile["clazz"] = clazz;
    dataProfile["address_line"] = addressLine;
    dataProfile["address_line_2"] = addressLine2;
    return dataProfile;
  }

  Map<String, String> get getJSONAvatar {
    final Map<String, String> avatarUrl = {};
    avatarUrl["avatar"] = avatar;
    return avatarUrl;
  }

  Profile handleChangeProfile({
    String? fullNameChange,
    String? genderChange,
    String? dobChange,
    String? phoneNumberChange,
    String? addressLineChange,
    String? addressLine2Change,
    String? avatarChange,
    String? parentEmailChange,
    String? schoolChange,
    String? clazzChange,
  }){
    return Profile(
      fullName: fullNameChange ?? fullName,
      gender: genderChange ?? gender,
      dob: dobChange ?? dob,
      phoneNumber: phoneNumberChange ?? phoneNumber,
      addressLine: addressLineChange ?? addressLine,
      addressLine2: addressLine2Change ?? addressLine2,
      avatar: avatarChange ?? avatar,
      parentEmail: parentEmailChange ?? parentEmail,
      school: schoolChange ?? school,
      clazz: clazzChange ?? clazz,
    );
  }
}