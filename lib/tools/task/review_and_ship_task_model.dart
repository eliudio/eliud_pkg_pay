import 'package:eliud_core/tools/random.dart';
import 'package:eliud_core/tools/widgets/dialog_helper.dart';
import 'package:eliud_pkg_notifications/platform/platform.dart';
import 'package:eliud_pkg_pay/tools/task/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/widgets/workflow_dialog_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewAndShipTaskModel extends TaskModel {
  static String PAY_TASK_FIELD_SHIPMENT_COMMENTS = 'shipment-comments';
  static String PAY_TASK_FIELD_REVIEW_RESULTS = 'review-result';
  static String PAY_TASK_FIELD_REVIEW_RESULT_OK = 'reviewed and ok';
  static String PAY_TASK_FIELD_REVIEW_RESULT_NOK = 'reviewed and not ok';

  final String extraParameter;

  ReviewAndShipTaskModel(
      {this.extraParameter, String description, bool executeInstantly})
      : super(description: description, executeInstantly: executeInstantly);

  @override
  TaskEntity toEntity({String appId}) {
    return ReviewAndShipTaskEntity(
        description: description, executeInstantly: executeInstantly);
  }

  static ReviewAndShipTaskModel fromEntity(ReviewAndShipTaskEntity entity) =>
      ReviewAndShipTaskModel(
          description: entity.description,
          executeInstantly: entity.executeInstantly);

  static ReviewAndShipTaskEntity fromMap(Map snap) => ReviewAndShipTaskEntity(
      description: snap['description'],
      executeInstantly: snap['executeInstantly']);

  String feedback;

  @override
  Future<void> startTask(
      BuildContext context, AssignmentModel assignmentModel) {
    feedback = null;
    DialogStatefulWidgetHelper.openIt(
      context,
      YesNoIgnoreDialogWithAssignmentResults(
          title: 'Payment',
          message:
              'Review the payment and ship the products. If you like you can provide some feedback to the buyer below.',
          resultsPrevious: assignmentModel.resultsPrevious,
          yesFunction: () => _reviewedOk(context, assignmentModel,
              feedback),
          noFunction: () => _reviewedNotOk(context, assignmentModel,
              feedback),
          extraFields: [
            DialogStateHelper().getListTile(
                leading: Icon(Icons.payment),
                title: DialogField(
                  valueChanged: (value) => feedback = value,
                  decoration: const InputDecoration(
                    hintText: 'Feedback to the buyer',
                    labelText: 'Feedback to the buyer',
                  ),
                ))
          ]),
    );
    return null;
  }

  void _reviewedOk(
      BuildContext context, AssignmentModel assignmentModel, String message) {
    var comment = 'Your payment has been reviewed and approved and your order is being prepared for shipment. ';
    if (message != null) comment = comment + message;
    AbstractNotificationPlatform.platform
        .sendMessage(context, assignmentModel.assigneeId, comment);
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
        ]));
  }

  void _reviewedNotOk(
      BuildContext context, AssignmentModel assignmentModel, String message) {
    var comment = 'Your payment has been reviewed and not accepted.';
    if (message != null) comment = comment + message;
    AbstractNotificationPlatform.platform
        .sendMessage(context, assignmentModel.assigneeId, comment);
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
        ]));
  }
}

class ReviewAndShipTaskModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) =>
      ReviewAndShipTaskModel.fromEntity(entity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => ReviewAndShipTaskModel.fromMap(map);
}
