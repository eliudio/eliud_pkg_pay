import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_dialog.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WebPaymentPlatform extends AbstractPaymentPlatform {
  @override
  void startPaymentProcess(AppModel app,
      BuildContext context, HandlePayment handlePayment, String? name, String? ccy, double? amount) {
    openErrorDialog(app, context, app.documentID + '/_paymenterror',
        title: 'Error',
        errorMessage: 'Stripe payment not implemented yet (existing stripe package not supported anymore)');
  }
}
