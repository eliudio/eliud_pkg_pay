import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_pkg_workflow/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:eliud_pkg_workflow/model/repository_singleton.dart';
import 'package:eliud_core/tools/random.dart';

enum PaymentType { Manual, Stripe }

PaymentType toPaymentType(int index) {
  switch (index) {
    case 0:
      return PaymentType.Manual;
    case 1:
      return PaymentType.Stripe;
  }
  return PaymentType.Manual;
}

abstract class PayModel extends TaskModel {
  final PaymentType paymentType;
  AssignmentModel assignmentModel;
  bool isNewAssignment;
  MemberModel member;

  PayModel({this.paymentType, String taskString})
      : super(taskString: taskString);

  void handlePayment(PaymentStatus status) {
    if (status is PaymentSucceeded) {
      // the below must become part of the TaskModel class "createNextAssignment"
      var tasks = assignmentModel.workflow.workflowTask;
      var found = -1;
      for (int i = 0; i < tasks.length; i++) {
        if (tasks[i].task.taskString == assignmentModel.task.taskString) {
          found = i;
          break;
        }
      }

      if (found >= 0) {
        if (found < tasks.length) {
          var nextTask = tasks[found+1];

          var newAssignee = member; // determine this based on nextTask.responsible
          var nextAssignment = AssignmentModel(
            documentID:newRandomKey(),
            appId: assignmentModel.appId,
            reporter: member,
            assignee: newAssignee,
            task: nextTask.task,
            workflow: assignmentModel.workflow,
            timestamp: null,
            triggeredBy: assignmentModel,
            results: null
          );
          AbstractRepositorySingleton.singleton.assignmentRepository(assignmentModel.appId).add(nextAssignment);
        } else {
          // no next task to do
        }
      } else {
        // task not found: error in workflow
      }

      // the below must become part of the TaskModel class "storeCurrentAssignment"
      if (isNewAssignment) {
        AbstractRepositorySingleton.singleton.assignmentRepository(
            assignmentModel.appId).add(assignmentModel);
      } else {
        AbstractRepositorySingleton.singleton.assignmentRepository(
            assignmentModel.appId).update(assignmentModel);
      }
    }
  }

  @override
  ExecutionResult execute(BuildContext context, AssignmentModel assignmentModel,
      bool isNewAssignment) {
    var accessState = AccessBloc.getState(context);
    if (accessState is LoggedIn) {
      this.assignmentModel = assignmentModel;
      this.isNewAssignment = isNewAssignment;
      this.member = accessState.member;
      var name = member.name;
      AbstractPaymentPlatform.platform.startPaymentProcess(
          context, handlePayment, name, getCcy(), getAmount());
    } else {
      // open dialog: not possible to pay without logged in
    }
  }

  String getCcy();
  double getAmount();
}

class FixedAmountPayModel extends PayModel {
  final String ccy;
  final double amount;

  FixedAmountPayModel({PaymentType paymentType, this.ccy, this.amount})
      : super(taskString: FixedAmountPayEntity.label, paymentType: paymentType);

  @override
  double getAmount() {
    return amount;
  }

  @override
  String getCcy() {
    return ccy;
  }

  @override
  TaskEntity toEntity({String appId}) =>
    FixedAmountPayEntity(paymentType: paymentType.index, ccy: ccy, amount: amount);

  static FixedAmountPayModel fromEntity(FixedAmountPayEntity entity) =>
      FixedAmountPayModel(paymentType: toPaymentType(entity.paymentType), ccy: entity.ccy, amount: entity.amount);
  static FixedAmountPayEntity fromMap(Map snap) =>
      FixedAmountPayEntity(paymentType: snap['paymentType'], ccy: snap['ccy'], amount: snap['amount']);
}

class FixedAmountPayModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) =>
      FixedAmountPayModel.fromEntity(entity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => FixedAmountPayModel.fromMap(map);
}

// Retrieve payment amount from the PayBloc (also part of this package)
class ContextAmountPayModel extends PayModel {
  ContextAmountPayModel(PaymentType paymentType)
      : super(taskString: FixedAmountPayEntity.label, paymentType: paymentType);

  @override
  double getAmount() {
    // Retrieve payment amount from the PayBloc (also part of this package)
    throw UnimplementedError();
  }

  @override
  String getCcy() {
    // retrieve from PayBloc
    throw UnimplementedError();
  }

  @override
  TaskEntity toEntity({String appId}) =>
      ContextAmountPayEntity(paymentType: paymentType.index);

  static ContextAmountPayModel fromEntity(ContextAmountPayEntity entity) =>
      ContextAmountPayModel(toPaymentType(entity.paymentType));
  static ContextAmountPayEntity fromMap(Map snap) => ContextAmountPayEntity(paymentType: snap['paymentType']);
}

class ContextAmountPayModelMapper implements TaskModelMapper {
  @override
  TaskModel fromEntity(TaskEntity entity) =>
      ContextAmountPayModel.fromEntity(entity);

  @override
  TaskModel fromEntityPlus(TaskEntity entity) => fromEntity(entity);

  @override
  TaskEntity fromMap(Map map) => ContextAmountPayModel.fromMap(map);
}
