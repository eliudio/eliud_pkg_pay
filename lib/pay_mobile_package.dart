import 'package:eliud_pkg_pay/pay_package.dart';
import 'package:eliud_pkg_pay/platform/mobile_payment_platform.dart';

import 'platform/payment_platform.dart';

class PayMobilePackage extends PayPackage {
  @override
  void init() {
    AbstractPaymentPlatform.platform = MobilePaymentPlatform();
    super.init();
  }


  @override
  List<Object?> get props => [
  ];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is PayMobilePackage &&
              runtimeType == other.runtimeType;
}
