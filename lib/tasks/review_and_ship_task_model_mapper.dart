import 'package:eliud_pkg_pay/tasks/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_pay/tasks/review_and_ship_task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model_mapper.dart';

class ReviewAndShipTaskModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) =>
      ReviewAndShipTaskModel.fromEntity(entity as ReviewAndShipTaskEntity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => ReviewAndShipTaskModel.fromMap(map);
}
