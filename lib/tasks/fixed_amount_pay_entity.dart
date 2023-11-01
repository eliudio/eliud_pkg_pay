import 'package:eliud_pkg_pay/tasks/pay_task_entity.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';

import 'fixed_amount_pay_model.dart';

class FixedAmountPayEntity extends PayTaskEntity {
  final String? ccy;
  final double? amount;

  FixedAmountPayEntity(
      {required String description,
        required bool executeInstantly,
        required PayTypeEntity paymentType,
      this.ccy,
      this.amount})
      : super(
            identifier: FixedAmountPayModel.label,
            description: description,
            executeInstantly: executeInstantly,
            paymentType: paymentType);

  @override
  Map<String, Object?> toDocument() {
    return {
      'identifier': identifier,
      'description': description,
      'executeInstantly': executeInstantly,
      'paymentType': paymentType.toDocument(),
      'ccy': ccy,
      'amount': amount
    };
  }
}
