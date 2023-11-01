import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';

import 'context_amount_pay_model.dart';
import 'pay_task_entity.dart';

class ContextAmountPayEntity extends PayTaskEntity {
  ContextAmountPayEntity(
      {required String description, required bool executeInstantly, required PayTypeEntity paymentType})
      : super(
      description: description,
      executeInstantly: executeInstantly,
      identifier: ContextAmountPayModel.label,
      paymentType: paymentType);

  @override
  Map<String, Object?> toDocument() {
    return {
      'identifier': identifier,
      'description': description,
      'executeInstantly': executeInstantly,
      'paymentType': paymentType.toDocument(),
    };
  }
}
