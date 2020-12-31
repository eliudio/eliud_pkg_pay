import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/bloc/pay_bloc.dart';
import 'package:eliud_pkg_pay/tools/bloc/pay_state.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_core/tools/widgets/dialog_helper.dart';
import 'package:eliud_pkg_pay/tools/task/pay_type_model.dart';
import 'package:eliud_pkg_pay/tools/task/widgets/manual_payment_dialog.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ***** PayModel *****

abstract class PayTaskModel extends TaskModel {
  final PayTypeModel paymentType;

  PayTaskModel({
    this.paymentType,
    String description,
  }) : super(description: description);

  void handleCreditCardPayment(BuildContext _context, AssignmentModel _assignmentModel, PaymentStatus status) {
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

  void handleManualPayment(BuildContext _context, AssignmentModel _assignmentModel, String paymentReference, String paymentName, bool success) {
    if (success) {
      // now store in results status.reference;
      finishTask(
          _context,
          _assignmentModel,
          ExecutionResults(ExecutionStatus.success, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-type',
                value: 'Manual Payment'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-reference',
                value: paymentReference),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: 'payment-name',
                value: paymentName)
          ]));
    } else {
      finishTask(
          _context, _assignmentModel, ExecutionResults(ExecutionStatus.delay));
    }
  }

  @override
  Future<void> startTask(BuildContext context, AssignmentModel assignmentModel) {
    var accessState = AccessBloc.getState(context);
    if (accessState is LoggedIn) {
      if (paymentType is CreditCardPayTypeModel) {
        var casted = paymentType as CreditCardPayTypeModel;
        if ((casted.requiresConfirmation != null) && (casted.requiresConfirmation)) {
          DialogStatefulWidgetHelper.openIt(
              context,
              YesNoDialog(
                  title: 'Payment',
                  message: 'Proceed with payment of ' +
                      getAmount(context).toString() +
                      ' ' +
                      getCcy(context) +
                      ' for ' +
                      assignmentModel.workflow.name +
                      '?',
                  yesFunction: () =>
                      _confirmedCreditCardPayment(
                          context, assignmentModel, accessState),
                  noFunction: () => Navigator.pop(context)
              ));
        } else {
          _creditCardPayment(
              context, assignmentModel, accessState);
        }
      } else if (paymentType is ManualPayTypeModel) {
        ManualPayTypeModel p = paymentType;
        DialogStatefulWidgetHelper.openIt(
            context,
            ManualPaymentDialog(
                purpose: assignmentModel.task.description,
                amount: getAmount(context),
                ccy: getCcy(context),
                payTo: p.payTo,
                country: p.country,
                bankIdentifierCode: p.bankIdentifierCode,
                payeeIBAN: p.payeeIBAN,
                bankName: p.bankName,
                payedWithTheseDetails: (paymentReference, String paymentName, bool success) => handleManualPayment(context, assignmentModel, paymentReference, paymentName, success)));
      }
    }
    return null;
  }

  void _confirmedCreditCardPayment(BuildContext context, AssignmentModel assignmentModel, AppLoaded accessState) {
    Navigator.pop(context);
    _creditCardPayment(
        context, assignmentModel, accessState);
  }

  void _creditCardPayment(BuildContext context, AssignmentModel assignmentModel, AppLoaded accessState) {
    AbstractPaymentPlatform.platform.startPaymentProcess(
        context,
        (PaymentStatus status) => handleCreditCardPayment(context, assignmentModel, status),
        accessState.getMember() == null
            ? 'unknown'
            : accessState.getMember().name,
        getCcy(context),
        getAmount(context));
  }

  String getCcy(BuildContext context);
  double getAmount(BuildContext context);
  String getOrderNumber(BuildContext context);
}

// ***** FixedAmountPayModel *****

class FixedAmountPayModel extends PayTaskModel {
  final String ccy;
  final double amount;

  FixedAmountPayModel(
      {String description, PayTypeModel paymentType, this.ccy, this.amount})
      : super(
            description: description,
            paymentType: paymentType);

  @override
  double getAmount(BuildContext context) {
    return amount;
  }

  @override
  String getCcy(BuildContext context) {
    return ccy;
  }

  @override
  TaskEntity toEntity({String appId}) => FixedAmountPayEntity(
      description: description,
      paymentType: paymentType.toEntity(),
      ccy: ccy,
      amount: amount);

  static FixedAmountPayModel fromEntity(FixedAmountPayEntity entity) =>
      FixedAmountPayModel(
          paymentType: PayTypeModel.fromEntity(entity.paymentType),
          description: entity.description,
          ccy: entity.ccy,
          amount: entity.amount);
  static FixedAmountPayEntity fromMap(Map snap) => FixedAmountPayEntity(
      description: snap['description'],
      paymentType: PayTypeModel.fromMap(snap['paymentType']),
      ccy: snap['ccy'],
      amount: double.tryParse(snap['amount'].toString()));

  @override
  String getOrderNumber(BuildContext context) => null;
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

// ***** ContextAmountPayModel *****

// Retrieve payment amount from the PayBloc (also part of this package)
class ContextAmountPayModel extends PayTaskModel {
  ContextAmountPayModel({String description, PayTypeModel paymentType})
      : super(
            description: description,
            paymentType: paymentType);

  @override
  TaskEntity toEntity({String appId}) => ContextAmountPayEntity(
      description: description, paymentType: paymentType.toEntity());

  static ContextAmountPayModel fromEntity(ContextAmountPayEntity entity) =>
      ContextAmountPayModel(
          description: entity.description,
          paymentType: PayTypeModel.fromEntity(entity.paymentType));

  static ContextAmountPayEntity fromMap(Map snap) => ContextAmountPayEntity(
      description: snap['description'],
      paymentType: PayTypeModel.fromMap(snap['paymentType']));

  InitializedPayState getState(BuildContext context) {
    try {
      var bloc = BlocProvider.of<PayBloc>(context);
      if (bloc != null) {
        var state = bloc.state;
        if (state is InitializedPayState) {
          return state;
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  String getOrderNumber(BuildContext context) {
    var state = getState(context);
    if (state is InitializedPayState) {
      return state.orderNumber;
    } else {
      return "?";
    }
  }

  @override
  double getAmount(BuildContext context) {
    var state = getState(context);
    if (state is InitializedPayState) {
      return state.amount;
    } else {
      return 0;
    }
  }

  @override
  String getCcy(BuildContext context) {
    var state = getState(context);
    if (state is InitializedPayState) {
      return state.ccy;
    } else {
      return "?";
    }
  }

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

