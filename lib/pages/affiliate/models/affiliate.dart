class Affiliate {
  final String code;
  final int createdAt;
  final int id;
  final String? note;
  final String numCustomer;
  final int numTxn;
  final String userEmail;
  final String userId;

  const Affiliate({
    required this.code,
    required this.createdAt,
    required this.id,
    this.note,
    required this.numCustomer,
    required this.numTxn,
    required this.userEmail,
    required this.userId,
  });

  static Affiliate emptyAffiliate() {
    return const Affiliate(
      code: "",
      createdAt: -1,
      id: -1,
      numCustomer: "",
      numTxn: -1,
      userEmail: "",
      userId: "",
    );
  }

  static List<Affiliate> convertDataToListAffiliate(List<dynamic> dataAPI) {
    List<Affiliate> listItem = dataAPI.map((item) {
      return Affiliate(
        code: item["code"],
        createdAt: item["created_at"],
        id: item["id"],
        note: item["note"],
        numCustomer: item["num_customer"],
        numTxn: item["num_txn"],
        userEmail: item["user_email"],
        userId: item["user_id"],
      );
    }).toList();
    return listItem;
  }

  static Affiliate createAAffiliateFromJson(Map<String, dynamic> data) {
    return Affiliate(
      code: data["code"],
      createdAt: data["created_at"],
      id: data["id"],
      note: data["note"],
      numCustomer: data["num_customer"],
      numTxn: data["num_txn"],
      userEmail: data["user_email"],
      userId: data["user_id"],
    );
  }
}
