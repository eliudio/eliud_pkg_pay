import 'package:eliud_core/core/base/model_base.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/pay_bloc.dart';
import 'bloc/pay_state.dart';
import 'context_amount_pay_entity.dart';
import 'pay_task_model.dart';

class ContextAmountPayModel extends PayTaskModel {
  static String label = 'PAY_TASK_CONTEXT_AMOUNT';
  static String definition = 'Pay an amount set by context (e.g. cart)';

  ContextAmountPayModel(
      {required String identifier, required String description, required bool executeInstantly, required PayTypeModel paymentType})
      : super(
            identifier: identifier,
            description: description,
            executeInstantly: executeInstantly,
            paymentType: paymentType);

  @override
  TaskEntity toEntity({String? appId, Set<ModelReference>? referencesCollector}) => ContextAmountPayEntity(
      description: description,
      executeInstantly: executeInstantly,
      paymentType: paymentType.toEntity());

  static ContextAmountPayModel fromEntity(ContextAmountPayEntity entity) =>
      ContextAmountPayModel(
          identifier: entity.identifier,
          description: entity.description,
          executeInstantly: entity.executeInstantly,
          paymentType: PayTypeModel.fromEntity(entity.paymentType));

  static ContextAmountPayEntity fromMap(Map snap) => ContextAmountPayEntity(
      description: snap['description'],
      executeInstantly: snap['executeInstantly'],
      paymentType: PayTypeModel.fromMap(snap['paymentType']));

  InitializedPayState? getState(BuildContext context) {
    try {
      var bloc = BlocProvider.of<PayBloc>(context);
      var state = bloc.state;
      if (state is InitializedPayState) {
        return state;
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
      return '?';
    }
  }

  @override
  double getAmount(BuildContext? context) {
    var state = getState(context!);
    if (state is InitializedPayState) {
      return state.amount;
    } else {
      return 0;
    }
  }

  @override
  String getCcy(BuildContext? context) {
    var state = getState(context!);
    if (state is InitializedPayState) {
      return state.ccy;
    } else {
      return '?';
    }
  }
}
