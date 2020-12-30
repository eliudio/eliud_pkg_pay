import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

class ReviewAndShipTaskEntity extends TaskEntity {
  static String label = 'REVIEW_AND_SHIP_TASK';
  final String extraParameter;

  ReviewAndShipTaskEntity({ this.extraParameter, String description }) : super(taskString: label, description: description);

  @override
  Map<String, Object> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
    };
  }

}
