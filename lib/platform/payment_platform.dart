import 'package:eliud_core_model/model/app_model.dart';
import 'package:flutter/cupertino.dart';

typedef HandlePayment = void Function(PaymentStatus status);

abstract class PaymentStatus {}

class PaymentSucceeded extends PaymentStatus {
  final String? reference;

  PaymentSucceeded(this.reference);
}

class PaymentFailure extends PaymentStatus {
  final String? error;
  final String? reference;

  PaymentFailure(this.error, this.reference);
}

abstract class AbstractPaymentPlatform {
  static late AbstractPaymentPlatform platform;

  void startPaymentProcess(AppModel app, BuildContext context,
      HandlePayment handlePayment, String? name, String? ccy, double? amount);
}

// 03.g02.10
