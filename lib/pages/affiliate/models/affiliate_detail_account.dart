class AffiliateDetailAccount {
  final String affiliateCode;
  final String affiliateCodeOwnerEmail;
  final int affiliateCodeOwnerId;
  final int affiliatedAt;
  final int rewardedCoin;
  final String userEmail;
  final String? userFullName;
  final int userId;
  final String? userPhoneNumber;
  final String userType;

  const AffiliateDetailAccount({
    required this.affiliateCode,
    required this.affiliateCodeOwnerEmail,
    required this.affiliateCodeOwnerId,
    required this.affiliatedAt,
    required this.rewardedCoin,
    required this.userEmail,
    this.userFullName,
    required this.userId,
    this.userPhoneNumber,
    required this.userType,
  });

  static List<AffiliateDetailAccount> convertDataToListAffiliateAccount(List<dynamic> dataAPI) {
    List<AffiliateDetailAccount> listItem = dataAPI.map((item) {
      return AffiliateDetailAccount(
        affiliateCode: item["affiliate_code"],
        affiliateCodeOwnerEmail: item["affiliate_code_owner_email"],
        affiliateCodeOwnerId: item["affiliate_code_owner_id"],
        affiliatedAt: item["affiliated_at"],
        rewardedCoin: item["rewarded_coin"],
        userEmail: item["user_email"],
        userFullName: item["user_fullname"],
        userId: item["user_id"],
        userPhoneNumber: item["user_phone_number"],
        userType: item["user_type"],
      );
    }).toList();
    return listItem;
  }
}
