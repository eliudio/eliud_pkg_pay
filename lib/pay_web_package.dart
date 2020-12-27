import 'package:eliud_pkg_pay/pay_package.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/platform/web_payment_platform.dart';

class PayWebPackage extends PayPackage {
  @override
  void init() {
    AbstractPaymentPlatform.platform = WebPaymentPlatform();
    super.init();
  }
}
