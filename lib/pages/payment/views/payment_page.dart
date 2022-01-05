import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pay/pay.dart';

import '../../../helpers/helpers.dart';
import '../../../models/models.dart';
import '../../../constants/constants.dart';
import '../../../widgets/widgets.dart';
import '../../../components/components.dart';
import '../../../layouts/layouts.dart';
import '../../pages.dart';

class PaymentPage extends StatefulWidget {
  final Course currentCourse;

  const PaymentPage({Key? key, required this.currentCourse}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late PaymentController _paymentController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _paymentController = Get.put(PaymentController(myContext: context, courseInfo: Rx<Course>(widget.currentCourse)));
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PaymentController>();
    super.dispose();
  }

  Widget _infoCourse() {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BannerImg(
          imageBanner: widget.currentCourse.coverImage,
          width: size.width - 18 * 2,
          height: ((size.width - 18 * 2) * 9) / 16,
        ),
        const SizedBox(height: 16),
        Text(
          widget.currentCourse.name,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(height: 16),
        InfoTeacher(
          imageUrl: widget.currentCourse.teacherAvatar,
          name: widget.currentCourse.teacherName,
          width: 50,
          height: 50,
          radius: 25,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                "${AppLocalizations.of(context)!.origin_price}:",
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Text(
              "${truncateNumberToString(widget.currentCourse.originPrice)} VNĐ",
              textAlign: TextAlign.right,
              maxLines: 1,
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                "${AppLocalizations.of(context)!.discount}:",
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Text(
              "-${truncateNumberToString(widget.currentCourse.originPrice - widget.currentCourse.price)}VNĐ",
              textAlign: TextAlign.right,
              maxLines: 1,
              style: TextStyle(
                color: $errorColor,
                fontSize: Theme.of(context).textTheme.headline4!.fontSize,
                fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
                fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
                letterSpacing: Theme.of(context).textTheme.headline4!.letterSpacing,
                height: Theme.of(context).textTheme.headline4!.height,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        const Line1(),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                "${AppLocalizations.of(context)!.price}:",
                maxLines: 1,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Text(
              "${truncateNumberToString(widget.currentCourse.price)} VNĐ",
              textAlign: TextAlign.right,
              maxLines: 1,
              style: TextStyle(
                color: $primaryColor,
                fontSize: Theme.of(context).textTheme.headline3!.fontSize,
                fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
                fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
                letterSpacing: Theme.of(context).textTheme.headline3!.letterSpacing,
                height: Theme.of(context).textTheme.headline3!.height,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _vnPay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Text(
          "1. VNPAY QR",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: $primaryColor),
          ),
          child: Image.asset(
            $assetsImageVNPay,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ButtonFullColor(
          textBtn: "${AppLocalizations.of(context)!.payment_with} VNPAY",
          onPressCallBack: () {
            _paymentController.transactionVNPay();
          },
          widthBtn: double.infinity,
          paddingBtn: const EdgeInsets.symmetric(vertical: 16),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _customInfoTransfer(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).textTheme.headline3!.color,
              fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
              fontFamily: Theme.of(context).textTheme.headline5!.fontFamily,
              height: Theme.of(context).textTheme.headline6!.height,
            ),
          ),
        ),
      ],
    );
  }

  Widget _transfer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Text(
          "2. ${AppLocalizations.of(context)!.transfer}",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 16,
        ),
        _customInfoTransfer("${AppLocalizations.of(context)!.bank}: ", $transaction["bank"] ?? ""),
        const SizedBox(
          height: 16,
        ),
        _customInfoTransfer("STK: ", $transaction["STK"] ?? ""),
        const SizedBox(
          height: 16,
        ),
        _customInfoTransfer("${AppLocalizations.of(context)!.name}: ", $transaction["name"] ?? ""),
        const SizedBox(
          height: 16,
        ),
        _customInfoTransfer("${AppLocalizations.of(context)!.branch}: ", $transaction["branch"] ?? ""),
        const SizedBox(
          height: 16,
        ),
        ButtonFullColor(
          textBtn: AppLocalizations.of(context)!.upload_image,
          onPressCallBack: () {
            getImage(context, ImageSource.gallery, (file) {
              if (file.path.isNotEmpty && file.path != $EMPTY) {
                _paymentController.uploadLocalImage(file);
              }
            });
          },
          paddingBtn: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          colorBtn: $yellow400,
        ),
        _paymentController.fileImageTransfer.value.path.isNotEmpty
            ? Image.file(
                _paymentController.fileImageTransfer.value,
                fit: BoxFit.fitWidth,
              )
            : Text(
                AppLocalizations.of(context)!.dont_have_image,
                style: const TextStyle(color: $errorColor),
              ),
        const SizedBox(
          height: 16,
        ),
        ButtonFullColor(
          textBtn: AppLocalizations.of(context)!.payment,
          onPressCallBack: () {
            _paymentController.transactionTransfer();
          },
          widthBtn: double.infinity,
          paddingBtn: const EdgeInsets.symmetric(vertical: 16),
        ),
      ],
    );
  }

  Widget _paymentApple() {
    final List<PaymentItem> _paymentItems = [
      PaymentItem(
        label: widget.currentCourse.name,
        amount: widget.currentCourse.price.toString(),
        status: PaymentItemStatus.final_price,
      )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Text(
          "3. Thanh toán bằng Apple",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: 8,
        ),
        ApplePayButton(
          paymentConfigurationAsset: 'apple_pay.json',
          paymentItems: _paymentItems,
          style: ApplePayButtonStyle.black,
          type: ApplePayButtonType.buy,
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: (value) {
            print(value);
          },
          onError: (error) {
            print(error);
          },
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),

        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }

  Widget _paymentGoogle() {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }

  Widget _transactionPlatform() {
    if (Platform.isAndroid) {
      return _paymentGoogle();
    } else if (Platform.isIOS) {
      return _paymentApple();
    } else {
      return const SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  Widget _transaction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context)!.payments,
          style: Theme.of(context).textTheme.headline3,
        ),
        _vnPay(),
        const SizedBox(
          height: 16,
        ),
        _transfer(),
        const SizedBox(
          height: 24,
        ),
        _transactionPlatform(),
      ],
    );
  }

  Widget _successPayment() {
    if (_paymentController.typeTransaction.value == $transfer) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.payment_success,
            style: TextStyle(
              color: $primaryColor,
              height: Theme.of(context).textTheme.headline3!.height,
              fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline3!.fontSize,
              fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
              letterSpacing: Theme.of(context).textTheme.headline3!.letterSpacing,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.transfer,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.pending_active,
            style: TextStyle(
              color: $yellow400,
              height: Theme.of(context).textTheme.headline4!.height,
              fontFamily: Theme.of(context).textTheme.headline4!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline4!.fontSize,
              fontWeight: Theme.of(context).textTheme.headline4!.fontWeight,
              letterSpacing: Theme.of(context).textTheme.headline4!.letterSpacing,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            AppLocalizations.of(context)!.support_after_payment,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.phone_number,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                width: 16,
              ),
              const Icon(Icons.phone)
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            child: Row(
              children: <Widget>[
                Text(
                  $phoneNumberSupport,
                  style: TextStyle(
                    color: $primaryColor,
                    fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                    fontFamily: Theme.of(context).textTheme.headline6!.fontFamily,
                    fontWeight: Theme.of(context).textTheme.headline6!.fontWeight,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.copy,
                  color: $primaryColor,
                )
              ],
            ),
            onTap: () {
              Clipboard.setData(const ClipboardData(text: $phoneNumberSupportCopy));
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonFullColorWithIconPrefix(
            textBtn: AppLocalizations.of(context)!.back_to_course,
            onPressCallBack: () {
              Navigator.pop(context);
            },
            paddingBtn: const EdgeInsets.symmetric(vertical: 12),
            widthBtn: double.infinity,
            iconBtn: const Icon(
              Icons.arrow_back_outlined,
              color: $whiteColor,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.payment_success,
            style: TextStyle(
              color: $primaryColor,
              height: Theme.of(context).textTheme.headline3!.height,
              fontFamily: Theme.of(context).textTheme.headline3!.fontFamily,
              fontSize: Theme.of(context).textTheme.headline3!.fontSize,
              fontWeight: Theme.of(context).textTheme.headline3!.fontWeight,
              letterSpacing: Theme.of(context).textTheme.headline3!.letterSpacing,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "VNPAY QR",
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "${AppLocalizations.of(context)!.date_payment}: ${DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.fromMillisecondsSinceEpoch(_paymentController.transactionDateVNPay.value * 1000))}",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 16,
          ),
          ButtonFullColorWithIconPrefix(
            textBtn: AppLocalizations.of(context)!.back_to_course,
            onPressCallBack: () {
              Navigator.pop(context);
            },
            paddingBtn: const EdgeInsets.symmetric(vertical: 12),
            widthBtn: double.infinity,
            iconBtn: const Icon(
              Icons.arrow_back_outlined,
              color: $whiteColor,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
    }
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          _infoCourse(),
          const SizedBox(
            height: 38,
          ),
          Obx(() {
            if (_paymentController.isSuccess.value) {
              return _successPayment();
            } else {
              return _transaction();
            }
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: simpleAppBar(
        context: context,
        title: AppLocalizations.of(context)!.course_payment,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: _body(),
      ),
    );
  }
}
