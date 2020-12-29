import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'manual/custom_dialog.dart';

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
      // now store in results status.reference;
      finishTask(
          _context,
          _assignmentModel,
          ExecutionResults(ExecutionStatus.success, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-type',
                value: 'Credit card'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-reference',
                value: status.reference)
          ]));
    } else if (status is PaymentFailure) {
      finishTask(
          _context,
          _assignmentModel,
          ExecutionResults(ExecutionStatus.failure, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-type',
                value: 'Credit card'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-reference',
                value: status.reference),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-error',
                value: status.error)
          ]));
    }
  }

  BuildContext _context;
  AssignmentModel _assignmentModel;

  @override
  void startTask(BuildContext context, AssignmentModel assignmentModel) {
    _context = context;
    _assignmentModel = assignmentModel;
    var accessState = AccessBloc.getState(context);
    if (accessState is LoggedIn) {
      if (paymentType == PaymentType.Stripe) {
        AbstractPaymentPlatform.platform.startPaymentProcess(
            context,
            handlePayment,
            accessState.member == null ? "unknown" : accessState.member.name,
            getCcy(),
            getAmount());
      } else {
        CustomDialog.openIt(context);
      }
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
  TaskEntity toEntity({String appId}) => FixedAmountPayEntity(
      paymentType: paymentType.index, ccy: ccy, amount: amount);

  static FixedAmountPayModel fromEntity(FixedAmountPayEntity entity) =>
      FixedAmountPayModel(
          paymentType: toPaymentType(entity.paymentType),
          ccy: entity.ccy,
          amount: entity.amount);
  static FixedAmountPayEntity fromMap(Map snap) => FixedAmountPayEntity(
      paymentType: snap['paymentType'],
      ccy: snap['ccy'],
      amount: double.tryParse(snap['amount'].toString()));
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
  static ContextAmountPayEntity fromMap(Map snap) =>
      ContextAmountPayEntity(paymentType: snap['paymentType']);
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
