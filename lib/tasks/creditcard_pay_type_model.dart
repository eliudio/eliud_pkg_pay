import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_model.dart';

class CreditCardPayTypeModel extends PayTypeModel {
  bool? requiresConfirmation;
  CreditCardPayTypeModel({this.requiresConfirmation}) : super();

  @override
  PayTypeEntity toEntity() => CreditCardPayTypeEntity(requiresConfirmation);

  static CreditCardPayTypeModel fromEntity(CreditCardPayTypeEntity entity) =>
      CreditCardPayTypeModel(requiresConfirmation: entity.requiresConfirmation);

  static PayTypeEntity fromMap(Map snap) {
    return CreditCardPayTypeEntity(snap['requiresConfirmation']);
  }
}
