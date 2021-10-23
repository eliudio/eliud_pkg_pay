import 'package:eliud_core/style/style_registry.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/tasks/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/execution_results.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/widgets/workflow_dialog_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewAndShipTaskModel extends TaskModel {
  static String label = 'REVIEW_AND_SHIP_TASK';
  static String definition = 'Review and ship';

  static String PAY_TASK_FIELD_SHIPMENT_COMMENTS = 'shipment-comments';
  static String PAY_TASK_FIELD_REVIEW_RESULTS = 'review-result';
  static String PAY_TASK_FIELD_REVIEW_RESULT_OK = 'reviewed and ok';
  static String PAY_TASK_FIELD_REVIEW_RESULT_NOK = 'reviewed and not ok';

  ReviewAndShipTaskModel(
      {required String identifier, required String description, required bool executeInstantly})
      : super(identifier: identifier, description: description, executeInstantly: executeInstantly);

  @override
  TaskEntity toEntity({String? appId}) {
    return ReviewAndShipTaskEntity(
        description: description, executeInstantly: executeInstantly);
  }

  static ReviewAndShipTaskModel fromEntity(ReviewAndShipTaskEntity entity) =>
      ReviewAndShipTaskModel(
          identifier: entity.identifier,
          description: entity.description,
          executeInstantly: entity.executeInstantly);

  static ReviewAndShipTaskEntity fromMap(Map snap) => ReviewAndShipTaskEntity(
      description: snap['description'],
      executeInstantly: snap['executeInstantly']);

  String? feedback;

  @override
  Future<void> startTask(
      BuildContext context, AssignmentModel? assignmentModel) {
    feedback = null;
    StyleRegistry.registry().styleWithContext(context).frontEndStyle().dialogStyle().openWidgetDialog(
      context,
      child: YesNoIgnoreDialogWithAssignmentResults.get(context,
          title: 'Payment',
          message:
              'Review the payment and ship the products. If you like you can provide some feedback to the buyer below.',
          resultsPrevious: assignmentModel!.resultsPrevious,
          yesFunction: () => _reviewedOk(context, assignmentModel, feedback!),
          noFunction: () => _reviewedNotOk(context, assignmentModel, feedback!),
          extraFields: [
            StyleRegistry.registry().styleWithContext(context).frontEndStyle().listTileStyle().getListTile(context,
                leading: Icon(Icons.payment),
                title: StyleRegistry.registry().styleWithContext(context).frontEndStyle().dialogFieldStyle().dialogField(context,
                  valueChanged: (value) => feedback = value,
                  decoration: const InputDecoration(
                    hintText: 'Feedback to the buyer',
                    labelText: 'Feedback to the buyer',
                  ),
                ))
          ]),
    );
    return Future.value(null);
  }

  void _reviewedOk(
      BuildContext context, AssignmentModel assignmentModel, String message) {
    var comment =
        'Payment reviewed and approved and order prepared for shipment.';
    if (message != null) comment = comment + ' Feedback: ' + message;
    Navigator.pop(context);
    finishTask(
        context,
        assignmentModel,
        ExecutionResults(ExecutionStatus.success, results: [
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: PAY_TASK_FIELD_REVIEW_RESULTS,
              value: PAY_TASK_FIELD_REVIEW_RESULT_OK),
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: PAY_TASK_FIELD_SHIPMENT_COMMENTS,
              value: comment),
        ]),
        message);
  }

  void _reviewedNotOk(
      BuildContext context, AssignmentModel assignmentModel, String message) {
    var comment = 'Payment reviewed and rejected.';
    if (message != null) comment = comment + ' Feedback: ' + message;
    Navigator.pop(context);
    finishTask(
        context,
        assignmentModel,
        ExecutionResults(ExecutionStatus.success, results: [
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: PAY_TASK_FIELD_REVIEW_RESULTS,
              value: PAY_TASK_FIELD_REVIEW_RESULT_NOK),
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: PAY_TASK_FIELD_SHIPMENT_COMMENTS,
              value: comment),
        ]),
        message);
  }
}
