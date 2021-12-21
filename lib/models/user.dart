class User{
  final int id;
  final int tenantId;
  final String email;
  final String? fullName;
  final String? gender;
  final String? dob;
  final String type;
  final String status;
  final bool emailVerified;
  final String? addressLine;
  final String? addressLine2;
  final String? phoneNumber;
  final bool phoneVerified;
  final String? avatar;
  final String? role;
  final String? parentEmail;
  final int? parentId;
  final String? referralToken;
  final String? apiKey;
  final String? apiKeyExpired;
  final String? provinceCode;
  final String? provinceName;
  final String? school;
  final String? clazz;
  final int numNotifications;
  final int totalUcoin;
  final int? currentExpLevel;
  final int totalExp;
  final int? nextExpLevelStart;
  final int? currentExpLevelStart;
  final String? lastLogin;
  final bool isHasPassword;
  final bool userTypeSet;

  const User({
    required this.id,
    required this.tenantId,
    required this.email,
    this.fullName,
    this.gender,
    this.dob,
    required this.type,
    required this.status,
    required this.emailVerified,
    this.addressLine,
    this.addressLine2,
    this.phoneNumber,
    required this.phoneVerified,
    this.avatar,
    this.role,
    this.parentEmail,
    this.parentId,
    this.referralToken,
    this.apiKey,
    this.apiKeyExpired,
    this.provinceCode,
    this.provinceName,
    this.school,
    this.clazz,
    required this.numNotifications,
    required this.totalUcoin,
    this.currentExpLevel,
    required this.totalExp,
    this.nextExpLevelStart,
    this.currentExpLevelStart,
    this.lastLogin,
    required this.isHasPassword,
    required this.userTypeSet
  });

  static const empty = User(
    id: 0,
    tenantId: 0,
    email: "",
    type: "",
    status: "",
    emailVerified: false,
    phoneVerified: false,
    numNotifications: 0,
    totalUcoin: 0,
    totalExp: 0,
    isHasPassword: false,
    userTypeSet: false,
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = tenantId;
    data['tenantId'] = tenantId;
    data['email'] = email;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['dob'] = dob;
    data['type'] = type;
    data['status'] = status;
    data['emailVerified'] = emailVerified;
    data['addressLine'] = addressLine;
    data['addressLine2'] = addressLine2;
    data['phoneNumber'] = phoneNumber;
    data['phoneVerified'] = phoneVerified;
    data['avatar'] = avatar;
    data['role'] = role;
    data['parentEmail'] = parentEmail;
    data['parentId'] = parentId;
    data['referralToken'] = referralToken;
    data['apiKey'] = apiKey;
    data['apiKeyExpired'] = apiKeyExpired;
    data['provinceCode'] = provinceCode;
    data['provinceName'] = provinceName;
    data['school'] = school;
    data['clazz'] = clazz;
    data['numNotifications'] = numNotifications;
    data['totalUcoin'] = totalUcoin;
    data['currentExpLevel'] = currentExpLevel;
    data['totalExp'] = totalExp;
    data['nextExpLevelStart'] = nextExpLevelStart;
    data['currentExpLevelStart'] = currentExpLevelStart;
    data['lastLogin'] = lastLogin;
    data['isHasPassword'] = isHasPassword;
    data['userTypeSet'] = userTypeSet;
    return data;
  }
}
