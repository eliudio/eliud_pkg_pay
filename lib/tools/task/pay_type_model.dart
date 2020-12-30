import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/platform/payment_platform.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_core/tools/widgets/dialog_helper.dart';
import 'package:eliud_pkg_pay/tools/task/pay_type_entity.dart';
import 'package:eliud_pkg_pay/tools/task/widgets/manual_payment_dialog.dart';
import 'package:eliud_pkg_workflow/model/assignment_model.dart';
import 'package:eliud_pkg_workflow/model/assignment_result_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
