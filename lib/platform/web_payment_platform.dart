import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/platform/web_helper/web_stripe_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebPaymentPlatform extends AbstractPaymentPlatform {
  @override
  void startPaymentProcess(AppModel app,
      BuildContext? context, HandlePayment handlePayment, String? name, String? ccy, double? amount) {
    debugPrint("startPaymentProcess");
    var cents = (amount! * 100).toInt();
    debugPrint("before showDialog");
    showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                width: 400.0,
                height: 100.0,
                child: WebStripeElements(
                    ccy: ccy,
                    name: name,
                    cents: cents,
                    handlePayment: handlePayment)),
          );
        });
  }
}
