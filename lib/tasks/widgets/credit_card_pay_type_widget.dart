import 'package:eliud_core_main/model/app_model.dart';
import 'package:flutter/material.dart';

import '../pay_type_types/creditcard_pay_type_model.dart';

typedef CreditCardPayTypeCallback = Function(CreditCardPayTypeModel payType);

class CreditCardPayTypeWidget extends StatefulWidget {
  final CreditCardPayTypeCallback payTypeCallback;
  final AppModel app;
  final CreditCardPayTypeModel model;

  const CreditCardPayTypeWidget(
      {super.key,
      required this.payTypeCallback,
      required this.model,
      required this.app});

  @override
  State<StatefulWidget> createState() => _CreditCardPayTypeWidgetState();
}

class _CreditCardPayTypeWidgetState extends State<CreditCardPayTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      // no fields (yet)
    ]);
  }
}
