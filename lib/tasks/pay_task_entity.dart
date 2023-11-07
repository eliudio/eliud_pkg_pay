import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

abstract class PayTaskEntity extends TaskEntity {
  final PayTypeEntity paymentType;

  const PayTaskEntity(
      {required super.identifier,
      required super.description,
      required super.executeInstantly,
      required this.paymentType});
}
