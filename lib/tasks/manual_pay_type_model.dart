import 'package:eliud_pkg_pay/tasks/pay_type_entity.dart';

import 'pay_type_model.dart';

class ManualPayTypeModel extends PayTypeModel {
  final String payTo;
  final String country;
  final String bankIdentifierCode;
  final String payeeIBAN;
  final String bankName;

  ManualPayTypeModel(
      {required this.payTo,
        required this.country,
        required this.bankIdentifierCode,
        required this.payeeIBAN,
        required this.bankName})
      : super();

  @override
  PayTypeEntity toEntity() => ManualPayTypeEntity(
      payTo: payTo, country: country, bankIdentifierCode: bankIdentifierCode, payeeIBAN: payeeIBAN, bankName: bankName);

  static ManualPayTypeModel fromEntity(ManualPayTypeEntity entity) =>
      ManualPayTypeModel(
          payTo: entity.payTo,
          country: entity.country,
          bankIdentifierCode: entity.bankIdentifierCode,
          payeeIBAN: entity.payeeIBAN,
          bankName: entity.bankName);

  static PayTypeEntity fromMap(Map snap) {
    return ManualPayTypeEntity(
      payTo: snap['payTo'] ?? '?',
      country: snap['country'] ?? '?',
      bankIdentifierCode: snap['bankIdentifierCode'] ?? '?',
      payeeIBAN: snap['payeeIBAN'] ?? '?',
      bankName: snap['bankName'] ?? '?',
    );
  }
}
