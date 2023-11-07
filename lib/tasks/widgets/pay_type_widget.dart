import 'package:eliud_core/model/app_model.dart';
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
  final PayTypeModel? model;

  PayTypeWidget(
      {super.key,
      required this.payTypeCallback,
      required this.model,
      required this.app});

  @override
  State<StatefulWidget> createState() => _PayTypeWidgetState(model);
}

class _PayTypeWidgetState extends State<PayTypeWidget> {
  PayTypeModel? model;

  _PayTypeWidgetState(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      PayTypeTypeWidget(
          app: widget.app,
          payTypeTypeCallback: (value) {
            setState(() {
              if (value == PayTypeType.manual) {
                model = ManualPayTypeModel(
                    payTo: '',
                    country: '',
                    bankIdentifierCode: '',
                    payeeIBAN: '',
                    bankName: '');
              } else {
                model = CreditCardPayTypeModel();
              }
              widget.payTypeCallback(model!);
            });
          },
          payTypeType: model is ManualPayTypeModel
              ? PayTypeType.manual
              : PayTypeType.creditCard),
      model is ManualPayTypeModel
          ? ManualPayTypeWidget(
              payTypeCallback: (ManualPayTypeModel payType) {
                widget.payTypeCallback(payType);
              },
              model: model as ManualPayTypeModel,
              app: widget.app,
            )
          : CreditCardPayTypeWidget(
              payTypeCallback: (CreditCardPayTypeModel payType) {
                widget.payTypeCallback(payType);
              },
              model: model as CreditCardPayTypeModel,
              app: widget.app)
    ]);
  }
}
