import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../pages.dart';

class PaymentController extends GetxController {
  final Rx<Course> courseInfo;
  final BuildContext myContext;

  RxBool isSuccess = RxBool(false);
  RxString typeTransaction = RxString("");

  RxInt transactionDateVNPay = RxInt(0);

  Rx<File> fileImageTransfer = Rx<File>(File(""));

  final CustomLoader _loader = CustomLoader();

  PaymentController({required this.myContext, required this.courseInfo});

  void uploadLocalImage(File fileImage){
    fileImageTransfer.value = fileImage;
  }

  Future<void> transactionVNPay() async {
    _loader.showLoader(myContext);
    LocaleProvider localeProvider = myContext.read<LocaleProvider>();
    String language = localeProvider.getCurrentLanguage().toString();
    DataResponse transfer = await transactionCourseResponse({
      "course_id": courseInfo.value.id,
      "language": language == "vi" ? "vn" : "en",
      "payment_method": $vnPayQR,
      "redirect_url": $urlWebViewHome,
    });
    _loader.hideLoader();
    if (transfer.status) {
      final vnPayRef = await Navigator.pushNamed(
        myContext,
        UrlRoutes.$returnUrlWebView,
        arguments: ReturnUrlPage(
          urlWebView: transfer.data["data"]["vnpay_payment_url"],
        ),
      ) as String;
      if (!vnPayRef.contains(RegExp(r'sandbox', caseSensitive: false)) &&
          vnPayRef.contains(RegExp(getReference!, caseSensitive: false))) {
        final getQueryUrl = Uri.dataFromString(vnPayRef);
        Map<String, String> params = getQueryUrl.queryParameters;
        String status = $pending;
        _loader.showLoader(myContext);
        while (status == $pending) {
          DataResponse acceptCourse = await transactionCourseDetailResponse(params["vnp_TxnRef"] ?? "");
          if (acceptCourse.status) {
            if (acceptCourse.data["data"]["status"] == $success) {
              status = $success;
              transactionDateVNPay.value = acceptCourse.data["data"]["transaction_date"];
              break;
            }
          } else {
            status = $failure;
            break;
          }
        }
        _loader.hideLoader();
        if (status == $failure) {
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.payment_failed, backgroundColor: $errorColor);
        } else {
          isSuccess.value = true;
          typeTransaction.value = $vnPayQR;
        }
      } else {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.payment_failed, backgroundColor: $errorColor);
      }
    } else {
      showSnackBar(myContext, message: AppLocalizations.of(myContext)!.payment_failed, backgroundColor: $errorColor);
    }
  }

  Future<void> transactionTransfer() async {
    if(fileImageTransfer.value.path.isNotEmpty){
      _loader.showLoader(myContext);
      DataResponse uploadImage = await upLoadImageResponse(fileImageTransfer.value, "payments");
      if (uploadImage.status) {
        LocaleProvider localeProvider = myContext.read<LocaleProvider>();
        String language = localeProvider.getCurrentLanguage().toString();
        DataResponse dataResponse = await transactionCourseResponse({
          "course_id": courseInfo.value.id,
          "language": language == "vi" ? "vn" : "en",
          "payment_image": uploadImage.data["data"],
          "payment_method": $bankTransfer,
        });
        if (dataResponse.status) {
          isSuccess.value = true;
          typeTransaction.value = $transfer;
        } else {
          showSnackBar(myContext, message: AppLocalizations.of(myContext)!.payment_failed, backgroundColor: $errorColor);
        }
      } else {
        showSnackBar(myContext, message: AppLocalizations.of(myContext)!.payment_failed, backgroundColor: $errorColor);
      }
      _loader.hideLoader();
    }
  }
}
