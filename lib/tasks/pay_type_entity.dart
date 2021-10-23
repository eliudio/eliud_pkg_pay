

// ***** PayTypeEntity *****

abstract class PayTypeEntity {
  Map<String, Object?> toDocument();
}

class ManualPayTypeEntity extends PayTypeEntity {
  final String payTo;
  final String country;
  final String bankIdentifierCode;
  final String payeeIBAN;
  final String bankName;

  ManualPayTypeEntity({required this.payTo, required this.country, required this.bankIdentifierCode, required this.payeeIBAN, required this.bankName}) : super();

  @override
  Map<String, Object?> toDocument() {
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
  bool? requiresConfirmation;
  CreditCardPayTypeEntity(this.requiresConfirmation) : super();

  @override
  Map<String, Object?> toDocument() {
    return {
      'paymentMethod': 'creditcard',
      'requiresConfirmation': requiresConfirmation,
    };
  }
}

