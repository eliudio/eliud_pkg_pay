import 'package:eliud_pkg_pay/tasks/pay_task_entity.dart';
import 'fixed_amount_pay_model.dart';

class FixedAmountPayEntity extends PayTaskEntity {
  final String? ccy;
  final double? amount;

  FixedAmountPayEntity(
      {required super.description,
      required super.executeInstantly,
      required super.paymentType,
      this.ccy,
      this.amount})
      : super(identifier: FixedAmountPayModel.label);

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
