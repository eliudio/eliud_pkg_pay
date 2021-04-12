import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

class ReviewAndShipTaskEntity extends TaskEntity {
  static String label = 'REVIEW_AND_SHIP_TASK';

  ReviewAndShipTaskEntity({String? description, bool? executeInstantly})
      : super(
            taskString: label,
            description: description,
            executeInstantly: executeInstantly);

  @override
  Map<String, Object?> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
      'executeInstantly': executeInstantly,
    };
  }
}
