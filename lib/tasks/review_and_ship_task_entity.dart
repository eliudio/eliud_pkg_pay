import 'package:eliud_pkg_pay/tasks/review_and_ship_task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

class ReviewAndShipTaskEntity extends TaskEntity {
  ReviewAndShipTaskEntity(
      {required super.description, required super.executeInstantly})
      : super(identifier: ReviewAndShipTaskModel.label);

  @override
  Map<String, Object?> toDocument() {
    return {
      'identifier': identifier,
      'description': description,
      'executeInstantly': executeInstantly,
    };
  }
}
