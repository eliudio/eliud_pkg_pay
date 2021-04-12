import 'package:eliud_pkg_pay/tools/task/pay_type_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

// ***** PayEntity *****

abstract class PayTaskEntity extends TaskEntity {
  final PayTypeEntity? paymentType;

  const PayTaskEntity(
      {String? taskString,
      String? description,
      bool? executeInstantly,
      this.paymentType})
      : super(
            taskString: taskString,
            description: description,
            executeInstantly: executeInstantly);
}

class FixedAmountPayEntity extends PayTaskEntity {
  static String label = 'PAY_TASK_FIXED_AMOUNT';

  final String? ccy;
  final double? amount;

  FixedAmountPayEntity(
      {String? description,
      bool? executeInstantly,
      PayTypeEntity? paymentType,
      this.ccy,
      this.amount})
      : super(
            description: description,
            executeInstantly: executeInstantly,
            taskString: label,
            paymentType: paymentType);

  @override
  Map<String, Object?> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
      'executeInstantly': executeInstantly,
      'paymentType': paymentType!.toDocument(),
      'ccy': ccy,
      'amount': amount
    };
  }
}

class ContextAmountPayEntity extends PayTaskEntity {
  static String label = 'PAY_TASK_CONTEXT_AMOUNT';

  ContextAmountPayEntity(
      {String? description, bool? executeInstantly, PayTypeEntity? paymentType})
      : super(
            description: description,
            executeInstantly: executeInstantly,
            taskString: label,
            paymentType: paymentType);

  @override
  Map<String, Object?> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
      'executeInstantly': executeInstantly,
      'paymentType': paymentType!.toDocument(),
    };
  }
}
