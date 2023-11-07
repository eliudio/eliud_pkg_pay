import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';

import 'creditcard_pay_type_model.dart';
import 'manual_pay_type_model.dart';

abstract class PayTypeModel {
  PayTypeModel();

  PayTypeEntity toEntity();

  static PayTypeModel fromEntity(PayTypeEntity? entity) {
    if (entity == null) throw Exception('PayTypeEntity is null');
    if (entity is ManualPayTypeEntity) {
      return ManualPayTypeModel.fromEntity(entity);
    } else if (entity is CreditCardPayTypeEntity) {
      return CreditCardPayTypeModel.fromEntity(entity);
    }
    throw Exception('Paytype for the following entity not supported: $entity');
  }

  static PayTypeEntity fromMap(Map? snap) {
    if (snap == null) throw Exception('PayTypeEntity snap is null');
    if (snap['paymentMethod'] == 'manual') {
      return ManualPayTypeModel.fromMap(snap);
    } else if (snap['paymentMethod'] == 'creditcard') {
      return CreditCardPayTypeModel.fromMap(snap);
    }
    throw Exception('Paytype for the following map not supported: $snap');
  }
}
