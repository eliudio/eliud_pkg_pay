import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_pkg_pay/tools/task/widgets/manual_payment_dialog.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class PayModel extends TaskModel {
  final PayTypeModel paymentType;
  AssignmentModel assignmentModel;
  bool isNewAssignment;
  MemberModel member;

  PayModel({this.paymentType, String taskString})
      : super(taskString: taskString);

  void handleCreditCardPayment(PaymentStatus status) {
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

  void handleManualPayment(
      String paymentReference, String paymentName, bool success) {
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

  BuildContext _context;
  AssignmentModel _assignmentModel;

  @override
  void startTask(BuildContext context, AssignmentModel assignmentModel) {
    _context = context;
    _assignmentModel = assignmentModel;
    var accessState = AccessBloc.getState(context);
    if (accessState is LoggedIn) {
      if (paymentType is CreditCardPayTypeModel) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Payment'),
              content: Text(
                  'Proceed with payment of ' + getAmount().toString() + ' ' + getCcy() + ' for ' + assignmentModel.workflow.name + '?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Continue'),
                  onPressed: () {
                    Navigator.pop(context);
                    AbstractPaymentPlatform.platform.startPaymentProcess(
                        context,
                        handleCreditCardPayment,
                        accessState.member == null
                            ? 'unknown'
                            : accessState.member.name,
                        getCcy(),
                        getAmount());
                  },
                ),
              ],
            );
          },
        );
      } else if (paymentType is ManualPayTypeModel) {
        ManualPayTypeModel p = paymentType;
        ManualPaymentDialog.openIt(
            context,
            ManualPaymentDialog(
                purpose: assignmentModel.workflow.name,
                amount: getAmount(),
                ccy: getCcy(),
                payTo: p.payTo,
                country: p.country,
                bankIdentifierCode: p.bankIdentifierCode,
                payeeIBAN: p.payeeIBAN,
                bankName: p.bankName,
                payedWithTheseDetails: handleManualPayment));
      }
    }
  }

  String getCcy();
  double getAmount();
}

class FixedAmountPayModel extends PayModel {
  final String ccy;
  final double amount;

  FixedAmountPayModel({PayTypeModel paymentType, this.ccy, this.amount})
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
      paymentType: paymentType.toEntity(), ccy: ccy, amount: amount);

  static FixedAmountPayModel fromEntity(FixedAmountPayEntity entity) =>
      FixedAmountPayModel(
          paymentType: PayTypeModel.fromEntity(entity.paymentType),
          ccy: entity.ccy,
          amount: entity.amount);
  static FixedAmountPayEntity fromMap(Map snap) => FixedAmountPayEntity(
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

// Retrieve payment amount from the PayBloc (also part of this package)
class ContextAmountPayModel extends PayModel {
  ContextAmountPayModel(PayTypeModel paymentType)
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
      ContextAmountPayEntity(paymentType: paymentType.toEntity());

  static ContextAmountPayModel fromEntity(ContextAmountPayEntity entity) =>
      ContextAmountPayModel(PayTypeModel.fromEntity(entity.paymentType));
  static ContextAmountPayEntity fromMap(Map snap) => ContextAmountPayEntity(
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
