import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:eliud_pkg_pay/tasks/widgets/pay_type_type_widget.dart';
import 'package:flutter/material.dart';

import '../pay_type_types/creditcard_pay_type_model.dart';
import '../pay_type_types/manual_pay_type_model.dart';
import '../pay_type_types/pay_type_model.dart';
import 'credit_card_pay_type_widget.dart';
import 'manual_pay_type_widget.dart';

typedef PayTypeCallback = Function(PayTypeModel payType);

class PayTypeWidget extends StatefulWidget {
  final PayTypeCallback payTypeCallback;
  final AppModel app;
  PayTypeModel? model;

  PayTypeWidget(
      {Key? key,
      required this.payTypeCallback,
      required this.model,
      required this.app})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PayTypeWidgetState();
}

class _PayTypeWidgetState extends State<PayTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      PayTypeTypeWidget(
          app: widget.app,
          payTypeTypeCallback: (value) {
            setState(() {
              if (value == PayTypeType.Manual) {
                widget.model = ManualPayTypeModel(
                    payTo: '',
                    country: '',
                    bankIdentifierCode: '',
                    payeeIBAN: '',
                    bankName: '');
              } else {
                widget.model = CreditCardPayTypeModel();
              }
              widget.payTypeCallback(widget.model!);
            });
          },
          payTypeType: widget.model is ManualPayTypeModel
              ? PayTypeType.Manual
              : PayTypeType.CreditCard),
      widget.model is ManualPayTypeModel
          ? ManualPayTypeWidget(
              payTypeCallback: (ManualPayTypeModel payType) {
                widget.payTypeCallback(payType);
              },
              model: widget.model as ManualPayTypeModel,
              app: widget.app,
            )
          : CreditCardPayTypeWidget(
              payTypeCallback: (CreditCardPayTypeModel payType) {
                widget.payTypeCallback(payType);
              },
              model: widget.model as CreditCardPayTypeModel,
              app: widget.app)
    ]);
  }
}
