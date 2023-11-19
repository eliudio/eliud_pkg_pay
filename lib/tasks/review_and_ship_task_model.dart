import 'package:eliud_core/core/base/model_base.dart';
import 'package:eliud_core_model/model/app_model.dart';
import 'package:eliud_core_model/style/frontend/has_dialog.dart';
import 'package:eliud_core_model/style/style_registry.dart';
import 'package:eliud_core_model/tools/etc/random.dart';
import 'package:eliud_pkg_pay/tasks/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/execution_results.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/widgets/workflow_dialog_helper.dart';
import 'package:flutter/material.dart';

class ReviewAndShipTaskModel extends TaskModel {
  static String label = 'REVIEW_AND_SHIP_TASK';
  static String definition = 'Review and ship';

  static String payTaskFiedlShipmentComments = 'shipment-comments';
  static String payTaskFieldReviewResults = 'review-result';
  static String payTaskFieldReviewResultOk = 'reviewed and ok';
  static String payTaskFieldReviewResultNOK = 'reviewed and not ok';

  ReviewAndShipTaskModel(
      {required super.identifier,
      required super.description,
      required super.executeInstantly});

  @override
  TaskEntity toEntity({
    String? appId,
  }) {
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
  Future<void> startTask(AppModel app, BuildContext context, String? memberId,
      AssignmentModel? assignmentModel) {
    feedback = null;
    openWidgetDialog(
      app,
      context,
      '${app.documentID}/payment',
      child: YesNoIgnoreDialogWithAssignmentResults.get(app, context,
          title: 'Payment',
          message:
              'Review the payment and ship the products. If you like you can provide some feedback to the buyer below.',
          resultsPrevious: assignmentModel!.resultsPrevious,
          yesFunction: () =>
              _reviewedOk(app, context, assignmentModel, feedback!),
          noFunction: () =>
              _reviewedNotOk(app, context, assignmentModel, feedback!),
          extraFields: [
            StyleRegistry.registry()
                .styleWithApp(app)
                .frontEndStyle()
                .listTileStyle()
                .getListTile(app, context,
                    leading: Icon(Icons.payment),
                    title: StyleRegistry.registry()
                        .styleWithApp(app)
                        .frontEndStyle()
                        .dialogFieldStyle()
                        .dialogField(
                          app,
                          context,
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

  void _reviewedOk(AppModel app, BuildContext context,
      AssignmentModel assignmentModel, String message) {
    var comment =
        'Payment reviewed and approved and order prepared for shipment.';
    comment = '$comment Feedback: $message';
    finishTask(
        app,
        context,
        assignmentModel,
        ExecutionResults(ExecutionStatus.success, results: [
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: payTaskFieldReviewResults,
              value: payTaskFieldReviewResultOk),
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: payTaskFiedlShipmentComments,
              value: comment),
        ]),
        message);
    Navigator.pop(context);
  }

  void _reviewedNotOk(AppModel app, BuildContext context,
      AssignmentModel assignmentModel, String message) {
    var comment = 'Payment reviewed and rejected.';
    comment = '$comment Feedback: $message';
    finishTask(
        app,
        context,
        assignmentModel,
        ExecutionResults(ExecutionStatus.success, results: [
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: payTaskFieldReviewResults,
              value: payTaskFieldReviewResultNOK),
          AssignmentResultModel(
              documentID: newRandomKey(),
              key: payTaskFiedlShipmentComments,
              value: comment),
        ]),
        message);
    Navigator.pop(context);
  }

  @override
  Future<List<ModelReference>> collectReferences({
    String? appId,
  }) async {
    return [];
  }
}
