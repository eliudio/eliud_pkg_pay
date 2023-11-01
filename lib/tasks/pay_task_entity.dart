import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';


abstract class PayTaskEntity extends TaskEntity {
  final PayTypeEntity paymentType;

  const PayTaskEntity(
      {required String identifier,
        required String description,
        required bool executeInstantly,
        required this.paymentType})
      : super(
            identifier: identifier,
            description: description,
            executeInstantly: executeInstantly);
}
