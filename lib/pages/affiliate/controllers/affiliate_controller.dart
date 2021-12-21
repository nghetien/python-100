import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/constants.dart';
import '../../../services/services.dart';
import '../../../widgets/widgets.dart';

import '../../pages.dart';

enum StatusLoadAffiliate{
  pending,
  success,
  failed,
}

class AffiliateController extends GetxController {
  final CustomLoader _loader = CustomLoader();

  /// init
  final BuildContext myContext;

  AffiliateController({required this.myContext});

  @override
  void onInit() {
    super.onInit();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      fetchMyAffiliate();
    });
  }

  ///--------------------------------------------------

  /// filter
  RxList<Affiliate> listMyAffiliate = RxList<Affiliate>([]);
  RxInt page = RxInt(1);
  RxInt maxPage = RxInt(2);

  /// check load more
  RxBool isLoadMore = RxBool(false);

  /// status loading
  Rx<StatusLoadAffiliate> loadingStatus = Rx<StatusLoadAffiliate>(StatusLoadAffiliate.pending);

  Future<void> fetchMyAffiliate() async {
    DataResponse res = await getMyAffiliateResponse({
      "page": "1",
      "pageSize": "10",
    });
    if (res.status) {
      page.value = res.metaData!["current_page"] ?? 1;
      maxPage.value = (res.metaData!["total_items"] / 10).ceil(); // Default pageSize = 10
      listMyAffiliate.value = Affiliate.convertDataToListAffiliate(res.data["data"]);
      loadingStatus.value = StatusLoadAffiliate.success;
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.load_data_fail, backgroundColor: $errorColor);
      loadingStatus.value = StatusLoadAffiliate.failed;
    }
  }

  Future<void> loadMoreMyAffiliate() async {
    if (isLoadMore.value) {
      return;
    }
    isLoadMore.value = true;
    DataResponse res = await getMyAffiliateResponse({
      "page": (page.value + 1).toString(),
      "pageSize": "10",
    });
    if (res.status) {
      page.value += 1;
      listMyAffiliate.value = [...listMyAffiliate, ...Affiliate.convertDataToListAffiliate(res.data["data"])];
      isLoadMore.value = false;
    }
  }

  ///--------------------------------------------------

  ///--------------------------------------------------

  /// create new affiliate
  RxString errorAffiliateCode = RxString("");

  void handleChangeAffiliateCode(String code) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
    if (code.isEmpty) {
      errorAffiliateCode.value = $EMPTY;
    } else if (code.length != 10) {
      errorAffiliateCode.value = $INVALID;
    } else if (!validCharacters.hasMatch(code)) {
      errorAffiliateCode.value = $INVALID;
    } else {
      errorAffiliateCode.value = "";
    }
  }

  Future<bool> addNewAffiliate(String code, String note) async {
    if (code.isEmpty) {
      errorAffiliateCode.value = $EMPTY;
      return false;
    } else if (errorAffiliateCode.value.isEmpty) {
      _loader.showLoader(myContext);
      DataResponse res = await createAffiliateCodeResponse({
        "code": code,
        "note": note,
      });
      if(res.status){
        _loader.hideLoader();
        showSnackBar(myContext, message: "Thêm mã giới thiệu thành công", backgroundColor: $primaryColor);
        loadingStatus.value = StatusLoadAffiliate.pending;
        fetchMyAffiliate();
        return true;
      }else{
        _loader.hideLoader();
        if(res.code == 412){
          showSnackBar(myContext, message: "Mã giới thiệu đã tồn tại", backgroundColor: $errorColor);
        }else{
          showSnackBar(myContext, message: "Thêm mới thất bại", backgroundColor: $errorColor);
        }
        return false;
      }
    }else{
      return false;
    }
  }

  ///--------------------------------------------------
}
