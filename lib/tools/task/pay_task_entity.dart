import 'package:eliud_pkg_workflow/tools/task/task_entity.dart';

// ***** PayEntity *****

abstract class PayEntity extends TaskEntity {
  final PayTypeEntity paymentType;

  const PayEntity( { String taskString, String description, this.paymentType }) : super(taskString: taskString, description: description);
}

class FixedAmountPayEntity extends PayEntity {
  static String label = 'PAY_TASK_FIXED_AMOUNT';

  final String ccy;
  final double amount;

  FixedAmountPayEntity({String description, PayTypeEntity paymentType, this.ccy, this.amount}) : super(description: description, taskString: label, paymentType: paymentType);

  @override
  Map<String, Object> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
      'paymentType': paymentType.toDocument(),
      'ccy': ccy,
      'amount': amount
    };
  }
}

class ContextAmountPayEntity extends PayEntity {
  static String label = 'PAY_TASK_CONTEXT_AMOUNT';

  ContextAmountPayEntity({String description, PayTypeEntity paymentType}) : super(description: description, taskString: label, paymentType: paymentType);

  @override
  Map<String, Object> toDocument() {
    return {
      'taskString': taskString,
      'description': description,
      'paymentType': paymentType.toDocument(),
    };
  }
}

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
  CreditCardPayTypeEntity() : super();

  @override
  Map<String, Object> toDocument() {
    return {
      'paymentMethod': 'creditcard'
    };
  }
}

