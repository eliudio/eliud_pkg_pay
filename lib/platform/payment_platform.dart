import 'package:flutter/cupertino.dart';

typedef void HandlePayment(PaymentStatus status);

abstract class PaymentStatus {}

class PaymentSucceeded extends PaymentStatus {
  final String? reference;

  PaymentSucceeded(this.reference);
}

class PaymentFailure extends PaymentStatus {
  final String? error;
  final String reference;

  PaymentFailure(this.error, this.reference);
}

abstract class AbstractPaymentPlatform {
  static late AbstractPaymentPlatform platform;

  void startPaymentProcess(BuildContext? context, HandlePayment handlePayment, String? name, String? ccy, double? amount);
}

// 03.g02.10