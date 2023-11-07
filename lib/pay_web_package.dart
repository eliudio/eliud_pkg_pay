import 'package:eliud_pkg_pay/pay_package.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/platform/web_payment_platform.dart';

PayPackage getPayPackage() => PayWebPackage();

class PayWebPackage extends PayPackage {
  @override
  void init() {
    AbstractPaymentPlatform.platform = WebPaymentPlatform();
    super.init();
  }

  @override
  List<Object?> get props => [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayWebPackage && runtimeType == other.runtimeType;

  @override
  int get hashCode => packageName.hashCode;
}
