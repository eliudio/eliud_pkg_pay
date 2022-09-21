import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_dialog.dart';
import 'package:eliud_core/style/style_registry.dart';
import 'payment_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobilePaymentPlatform extends AbstractPaymentPlatform {
  final bool? requiresConfirmation;

  MobilePaymentPlatform({this.requiresConfirmation});

  @override
  void startPaymentProcess(AppModel app, BuildContext context, HandlePayment handlePayment, String? name, String? ccy, double? amount) {
    openErrorDialog(app, context, app.documentID + '/_paymenterror',
        title: 'Error',
        errorMessage: 'Stripe payment not implemented (existing stripe package not supported anymore)');
  }
}
