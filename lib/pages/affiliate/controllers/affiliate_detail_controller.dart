import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class AffiliateDetailController extends GetxController {
  /// init
  final BuildContext myContext;

  AffiliateDetailController({required this.myContext});

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchAffiliateAccount();
    });
  }

  ///--------------------------------------------------

  /// account
  RxList<AffiliateDetailAccount> listDetailAffiliateAccount = RxList<AffiliateDetailAccount>([]);
  RxInt pageAccount = RxInt(1);
  RxInt maxPageAccount = RxInt(2);

  /// check load more
  RxBool isLoadMoreAccount = RxBool(false);

  /// status loading
  Rx<StatusLoadAffiliate> loadingStatusAccount = Rx<StatusLoadAffiliate>(StatusLoadAffiliate.pending);

  Future<void> fetchAffiliateAccount() async {
    DataResponse res = await getDetailAffiliateAccount({
      "page": "1",
      "pageSize": "10",
    });
    if (res.status) {
      pageAccount.value = res.metaData!["current_page"] ?? 1;
      maxPageAccount.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listDetailAffiliateAccount.value = AffiliateDetailAccount.convertDataToListAffiliateAccount(res.data["data"]);
      loadingStatusAccount.value = StatusLoadAffiliate.success;
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
      loadingStatusAccount.value = StatusLoadAffiliate.failed;
    }
  }

  Future<void> loadMoreMyAffiliateAccount() async {
    if (isLoadMoreAccount.value) {
      return;
    }
    isLoadMoreAccount.value = true;
    DataResponse res = await getMyAffiliateResponse({
      "page": (pageAccount.value + 1).toString(),
      "pageSize": "10",
    });
    if (res.status) {
      pageAccount.value += 1;
      listDetailAffiliateAccount.value = [
        ...listDetailAffiliateAccount,
        ...AffiliateDetailAccount.convertDataToListAffiliateAccount(res.data["data"])
      ];
      isLoadMoreAccount.value = false;
    }
  }

  ///--------------------------------------------------

  ///--------------------------------------------------

  /// create new affiliate

  ///--------------------------------------------------
}
