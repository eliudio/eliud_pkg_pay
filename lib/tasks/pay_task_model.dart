import 'package:eliud_core/core/blocs/access/access_bloc.dart';
import 'package:eliud_core/core/blocs/access/state/access_determined.dart';
import 'package:eliud_core/core/blocs/access/state/logged_in.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_dialog.dart';
import 'package:eliud_core/style/style_registry.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/widgets/manual_payment_dialog.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/execution_results.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'creditcard_pay_type_model.dart';
import 'manual_pay_type_model.dart';

// ***** PayModel *****

abstract class PayTaskModel extends TaskModel {
  static String PAY_TASK_FIELD_PAYMENT_TYPE = 'payment-type';
  static String PAY_TASK_FIELD_PAYMENT_REFERENCE = 'payment-reference';
  static String PAY_TASK_FIELD_ERROR = 'payment-error';
  static String PAY_TASK_FIELD_NAME = 'payment-name';

  final PayTypeModel paymentType;

  PayTaskModel({
    required String identifier,
    required this.paymentType,
    required String description,
    required bool executeInstantly,
  }) : super(identifier: identifier, description: description, executeInstantly: executeInstantly);

  void handleCreditCardPayment(AppModel app, BuildContext _context,
      AssignmentModel? _assignmentModel, PaymentStatus status) {
    if (status is PaymentSucceeded) {
      // now store in results status.reference;
      finishTask(app,
          _context,
          _assignmentModel!,
          ExecutionResults(ExecutionStatus.success, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_TYPE,
                value: 'Credit card'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_REFERENCE,
                value: status.reference)
          ]),
          null);
    } else if (status is PaymentFailure) {
      finishTask(app,
          _context,
          _assignmentModel!,
          ExecutionResults(ExecutionStatus.failure, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_TYPE,
                value: 'Credit card'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_REFERENCE,
                value: status.reference),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_ERROR,
                value: status.error)
          ]),
          null);
    }
  }

  void handleManualPayment(
      AppModel app,
      BuildContext _context,
      AssignmentModel? _assignmentModel,
      String paymentReference,
      String paymentName,
      bool success) {
    if (success) {
      // now store in results status.reference;
      finishTask(app,
          _context,
          _assignmentModel!,
          ExecutionResults(ExecutionStatus.success, results: [
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_TYPE,
                value: 'Manual Payment'),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_PAYMENT_REFERENCE,
                value: paymentReference),
            AssignmentResultModel(
                documentID: newRandomKey(),
                key: PAY_TASK_FIELD_NAME,
                value: paymentName)
          ]),
          null);
    } else {
      finishTask(app, _context, _assignmentModel!,
          ExecutionResults(ExecutionStatus.delay), null);
    }
  }

  @override
  Future<void> startTask(AppModel app,
      BuildContext context, String? memberId, AssignmentModel? assignmentModel) {
    var accessState = AccessBloc.getState(context);
    if (accessState is LoggedIn) {
      if (paymentType is CreditCardPayTypeModel) {
        var casted = paymentType as CreditCardPayTypeModel;
        if ((casted.requiresConfirmation != null) &&
            casted.requiresConfirmation!) {
          openAckNackDialog(app, context,
              app.documentID + '/payment',
              title: 'Payment',
              message: 'Proceed with payment of ' +
                  getAmount(context).toString() +
                  ' ' +
                  getCcy(context)! +
                  ' for ' +
                  assignmentModel!.workflow!.name! +
                  '?', onSelection: (value) {
            if (value == 0) {
              _confirmedCreditCardPayment(app,
                  context, assignmentModel, accessState);
            }
          });
        } else {
          _creditCardPayment(app, context, assignmentModel, accessState);
        }
      } else if (paymentType is ManualPayTypeModel) {
        var p = paymentType as ManualPayTypeModel;
        openWidgetDialog(app,
            context,
            app.documentID + '/payment',
            child: ManualPaymentDialog(app:app,
                purpose: assignmentModel!.task!.description,
                amount: getAmount(context),
                ccy: getCcy(context),
                payTo: p.payTo,
                country: p.country,
                bankIdentifierCode: p.bankIdentifierCode,
                payeeIBAN: p.payeeIBAN,
                bankName: p.bankName,
                payedWithTheseDetails:
                    (paymentReference, String paymentName, bool success) =>
                        handleManualPayment(app, context, assignmentModel,
                            paymentReference, paymentName, success)));
      }
    }
    return Future.value(null);
  }

  void _confirmedCreditCardPayment(AppModel app, BuildContext context,
      AssignmentModel? assignmentModel, AccessDetermined accessState) {
    _creditCardPayment(app, context, assignmentModel, accessState);
  }

  void _creditCardPayment(AppModel app, BuildContext context,
      AssignmentModel? assignmentModel, AccessDetermined accessState) {
    AbstractPaymentPlatform.platform.startPaymentProcess(app,
        context,
        (PaymentStatus status) =>
            handleCreditCardPayment(app, context, assignmentModel, status),
        accessState.getMember() == null
            ? 'unknown'
            : accessState.getMember()!.name,
        getCcy(context),
        getAmount(context));
  }

  String? getCcy(BuildContext context);
  double? getAmount(BuildContext context);
  String? getOrderNumber(BuildContext context);
}

