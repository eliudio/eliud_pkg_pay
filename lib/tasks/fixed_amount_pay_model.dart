import 'package:eliud_core/core/base/model_base.dart';
import 'package:eliud_pkg_pay/tasks/pay_task_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/pay_type_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fixed_amount_pay_entity.dart';

class FixedAmountPayModel extends PayTaskModel {
  static String label = 'PAY_TASK_FIXED_AMOUNT';
  static String definition = 'Pay a fixed amount';

  String? ccy;
  double? amount;

  FixedAmountPayModel(
      {required String identifier,
        required String description,
        required bool executeInstantly,
        required PayTypeModel paymentType,
      this.ccy,
      this.amount})
      : super(
      identifier: identifier,
            description: description,
            executeInstantly: executeInstantly,
            paymentType: paymentType);

  @override
  double? getAmount(BuildContext? context) {
    return amount;
  }

  @override
  String? getCcy(BuildContext? context) {
    return ccy;
  }

  @override
  TaskEntity toEntity({String? appId, }) => FixedAmountPayEntity(
      description: description,
      executeInstantly: executeInstantly,
      paymentType: paymentType.toEntity(),
      ccy: ccy,
      amount: amount);

  static FixedAmountPayModel fromEntity(FixedAmountPayEntity entity) =>
      FixedAmountPayModel(
          identifier: entity.identifier,
          paymentType: PayTypeModel.fromEntity(entity.paymentType),
          description: entity.description,
          executeInstantly: entity.executeInstantly,
          ccy: entity.ccy,
          amount: entity.amount);
  static FixedAmountPayEntity fromMap(Map snap) => FixedAmountPayEntity(
      description: snap['description'],
      executeInstantly: snap['executeInstantly'],
      paymentType: PayTypeModel.fromMap(snap['paymentType']),
      ccy: snap['ccy'],
      amount: double.tryParse(snap['amount'].toString()));

  @override
  String? getOrderNumber(BuildContext context) => null;

  @override
  Future<List<ModelReference>> collectReferences({String? appId, }) async {
    return [];
  }
}

