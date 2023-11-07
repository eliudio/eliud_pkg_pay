import 'context_amount_pay_model.dart';
import 'pay_task_entity.dart';

class ContextAmountPayEntity extends PayTaskEntity {
  ContextAmountPayEntity(
      {required super.description,
      required super.executeInstantly,
      required super.paymentType})
      : super(identifier: ContextAmountPayModel.label);

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
