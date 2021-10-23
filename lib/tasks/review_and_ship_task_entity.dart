import 'package:eliud_pkg_pay/tasks/review_and_ship_task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

class ReviewAndShipTaskEntity extends TaskEntity {

  ReviewAndShipTaskEntity({required String description, required bool executeInstantly})
      : super(
            identifier: ReviewAndShipTaskModel.label,
            description: description,
            executeInstantly: executeInstantly);

  @override
  Map<String, Object?> toDocument() {
    return {
      'identifier': identifier,
      'description': description,
      'executeInstantly': executeInstantly,
    };
  }
}
