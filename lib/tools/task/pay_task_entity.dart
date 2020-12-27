import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

abstract class PayEntity extends TaskEntity {
  final int paymentType;

  const PayEntity( { String taskString, this.paymentType }) : super(taskString: taskString);
}

class FixedAmountPayEntity extends PayEntity {
  static String label = "PAY_TASK_FIXED_AMOUNT";

  final String ccy;
  final double amount;

  FixedAmountPayEntity({int paymentType, this.ccy, this.amount}) : super(taskString: label, paymentType: paymentType);

  @override
  List<Object> get props => [ taskString, paymentType, ccy, amount ];

  Map<String, Object> toDocument() {
    return {
      "taskString": taskString,
      "paymentType": paymentType,
      "ccy": ccy,
      "amount": amount
    };
  }
}

class ContextAmountPayEntity extends PayEntity {
  static String label = "PAY_TASK_CONTEXT_AMOUNT";

  ContextAmountPayEntity({int paymentType}) : super(taskString: label, paymentType: paymentType);

  @override
  List<Object> get props => [ taskString, paymentType ];

  Map<String, Object> toDocument() {
    return {
      "taskString": taskString,
      "paymentType": paymentType,
    };
  }
}
