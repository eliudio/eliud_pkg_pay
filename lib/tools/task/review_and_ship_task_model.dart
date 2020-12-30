import 'package:eliud_core/tools/random.dart';
import 'package:eliud_core/tools/widgets/dialog_helper.dart';
import 'package:eliud_pkg_pay/tools/task/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/widgets/workflow_dialog_helper.dart';
import 'package:flutter/cupertino.dart';

class ReviewAndShipTaskModel extends TaskModel {
  final String extraParameter;

  ReviewAndShipTaskModel({this.extraParameter, String description}) : super(description: description);

  @override
  TaskEntity toEntity({String appId}) {
    return ReviewAndShipTaskEntity();
  }

  static ReviewAndShipTaskModel fromEntity(ReviewAndShipTaskEntity entity) => ReviewAndShipTaskModel(extraParameter: entity.extraParameter, description: entity.description);
  static ReviewAndShipTaskEntity fromMap(Map snap) => ReviewAndShipTaskEntity(description: snap['description']);

  @override
  Future<void> startTask(BuildContext context, AssignmentModel assignmentModel) {
    DialogStatefulWidgetHelper.openIt(
        context,
        YesNoDialogWithAssignmentResults(
            title: 'Payment',
            message: 'Review the payment and ship the products',
            resultsPrevious: assignmentModel.resultsPrevious,
            yesFunction: () => _reviewed(context, assignmentModel),
            noFunction: () => Navigator.pop(context)
        ));
  }

  void _reviewed(BuildContext context, AssignmentModel assignmentModel) {
    Navigator.pop(context);
    finishTask(
        context,
        assignmentModel,
        ExecutionResults(ExecutionStatus.success, results:
          assignmentModel.resultsPrevious // copy the results from the previous assignment as the results of this assignment
        ));
  }
}

class ReviewAndShipTaskModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) => ReviewAndShipTaskModel.fromEntity(entity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => ReviewAndShipTaskModel.fromMap(map);
}