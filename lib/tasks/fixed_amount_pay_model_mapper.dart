import 'package:eliud_pkg_pay/tasks/pay_task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model_mapper.dart';

import 'fixed_amount_pay_entity.dart';
import 'fixed_amount_pay_model.dart';

class FixedAmountPayModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) =>
      FixedAmountPayModel.fromEntity(entity as FixedAmountPayEntity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => FixedAmountPayModel.fromMap(map);
}
