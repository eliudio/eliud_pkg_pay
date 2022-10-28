import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:flutter/material.dart';

import '../pay_type_types/creditcard_pay_type_model.dart';

typedef CreditCardPayTypeCallback = Function(
    CreditCardPayTypeModel payType);

class CreditCardPayTypeWidget extends StatefulWidget {
  final CreditCardPayTypeCallback payTypeCallback;
  final AppModel app;
  final CreditCardPayTypeModel model;

  const CreditCardPayTypeWidget(
      {Key? key, required this.payTypeCallback, required this.model, required this.app})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreditCardPayTypeWidgetState();
}

class _CreditCardPayTypeWidgetState
    extends State<CreditCardPayTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      // no fields (yet)
    ]);
  }
}
