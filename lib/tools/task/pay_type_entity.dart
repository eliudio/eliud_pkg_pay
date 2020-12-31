import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

// ***** PayTypeEntity *****

abstract class PayTypeEntity {
  Map<String, Object> toDocument();
}

class ManualPayTypeEntity extends PayTypeEntity {
  final String payTo;
  final String country;
  final String bankIdentifierCode;
  final String payeeIBAN;
  final String bankName;

  ManualPayTypeEntity(this.payTo, this.country, this.bankIdentifierCode, this.payeeIBAN, this.bankName) : super();

  @override
  Map<String, Object> toDocument() {
    return {
      'paymentMethod': 'manual',
      'payTo': payTo,
      'country': country,
      'bankIdentifierCode': bankIdentifierCode,
      'payeeIBAN': payeeIBAN,
      'bankName': bankName
    };
  }
}

class CreditCardPayTypeEntity extends PayTypeEntity {
  bool requiresConfirmation;
  CreditCardPayTypeEntity(this.requiresConfirmation) : super();

  @override
  Map<String, Object> toDocument() {
    return {
      'paymentMethod': 'creditcard',
      'requiresConfirmation': requiresConfirmation,
    };
  }
}

