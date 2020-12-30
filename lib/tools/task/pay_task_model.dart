import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_core/tools/widgets/dialog_helper.dart';
import 'package:eliud_pkg_pay/tools/task/widgets/manual_payment_dialog.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ***** PayModel *****

abstract class PayModel extends TaskModel {
  final PayTypeModel paymentType;

  PayModel({
    this.paymentType,
    String taskString,
    String description,
  }) : super(taskString: taskString, description: description);

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
        DialogStatefulWidgetHelper.openIt(
            context,
            YesNoDialog(
              title: 'Payment',
              message: 'Proceed with payment of ' +
                  getAmount().toString() +
                  ' ' +
                  getCcy() +
                  ' for ' +
                  assignmentModel.workflow.name +
                  '?',
              yesFunction: () => _confirmedCreditCardPayment(context, assignmentModel, accessState),
              noFunction: () => Navigator.pop(context)
            ));
      } else if (paymentType is ManualPayTypeModel) {
        ManualPayTypeModel p = paymentType;
        DialogStatefulWidgetHelper.openIt(
            context,
            ManualPaymentDialog(
                purpose: assignmentModel.task.description,
                amount: getAmount(),
                ccy: getCcy(),
                payTo: p.payTo,
                country: p.country,
                bankIdentifierCode: p.bankIdentifierCode,
                payeeIBAN: p.payeeIBAN,
                bankName: p.bankName,
                payedWithTheseDetails: (paymentReference, String paymentName, bool success) => handleManualPayment(context, assignmentModel, paymentReference, paymentName, success)));
      }
    }
  }

  void _confirmedCreditCardPayment(BuildContext context, AssignmentModel assignmentModel, AppLoaded accessState) {
    Navigator.pop(context);
    AbstractPaymentPlatform.platform.startPaymentProcess(
        context,
        (PaymentStatus status) => handleCreditCardPayment(context, assignmentModel, status),
        accessState.getMember() == null
            ? 'unknown'
            : accessState.getMember().name,
        getCcy(),
        getAmount());
  }

  String getCcy();
  double getAmount();
}

// ***** FixedAmountPayModel *****

class FixedAmountPayModel extends PayModel {
  final String ccy;
  final double amount;

  FixedAmountPayModel(
      {String description, PayTypeModel paymentType, this.ccy, this.amount})
      : super(
            taskString: FixedAmountPayEntity.label,
            description: description,
            paymentType: paymentType);

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
class ContextAmountPayModel extends PayModel {
  ContextAmountPayModel({String description, PayTypeModel paymentType})
      : super(
            taskString: ContextAmountPayEntity.label,
            description: description,
            paymentType: paymentType);

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
  TaskEntity toEntity({String appId}) => ContextAmountPayEntity(
      description: description, paymentType: paymentType.toEntity());

  static ContextAmountPayModel fromEntity(ContextAmountPayEntity entity) =>
      ContextAmountPayModel(
          description: entity.description,
          paymentType: PayTypeModel.fromEntity(entity.paymentType));

  static ContextAmountPayEntity fromMap(Map snap) => ContextAmountPayEntity(
      description: snap['description'],
      paymentType: PayTypeModel.fromMap(snap['paymentType']));
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

// ***** PayTypeModel *****

abstract class PayTypeModel {
  PayTypeModel();

  PayTypeEntity toEntity();

  static PayTypeModel fromEntity(PayTypeEntity entity) {
    if (entity is ManualPayTypeEntity) {
      return ManualPayTypeModel.fromEntity(entity);
    } else if (entity is CreditCardPayTypeEntity) {
      return CreditCardPayTypeModel.fromEntity(entity);
    }
    return null;
  }

  static PayTypeEntity fromMap(Map snap) {
    if (snap == null) return null;
    if (snap['paymentMethod'] == 'manual') {
      return ManualPayTypeModel.fromMap(snap);
    } else if (snap['paymentMethod'] == 'creditcard') {
      return CreditCardPayTypeModel.fromMap(snap);
    }
    return null;
  }
}

class ManualPayTypeModel extends PayTypeModel {
  final String payTo;
  final String country;
  final String bankIdentifierCode;
  final String payeeIBAN;
  final String bankName;

  ManualPayTypeModel(
      {this.payTo,
      this.country,
      this.bankIdentifierCode,
      this.payeeIBAN,
      this.bankName})
      : super();

  @override
  PayTypeEntity toEntity() => ManualPayTypeEntity(
      payTo, country, bankIdentifierCode, payeeIBAN, bankName);

  static ManualPayTypeModel fromEntity(ManualPayTypeEntity entity) =>
      ManualPayTypeModel(
          payTo: entity.payTo,
          country: entity.country,
          bankIdentifierCode: entity.bankIdentifierCode,
          payeeIBAN: entity.payeeIBAN,
          bankName: entity.bankName);

  static PayTypeEntity fromMap(Map snap) {
    return ManualPayTypeEntity(
      snap['payTo'],
      snap['country'],
      snap['bankIdentifierCode'],
      snap['payeeIBAN'],
      snap['bankName'],
    );
  }
}

class CreditCardPayTypeModel extends PayTypeModel {
  CreditCardPayTypeModel() : super();

  @override
  PayTypeEntity toEntity() => CreditCardPayTypeEntity();

  static CreditCardPayTypeModel fromEntity(CreditCardPayTypeEntity entity) =>
      CreditCardPayTypeModel();

  static PayTypeEntity fromMap(Map snap) {
    return CreditCardPayTypeEntity();
  }
}
