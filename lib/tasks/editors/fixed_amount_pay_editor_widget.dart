import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/widgets/pay_type_widget.dart';
import 'package:flutter/material.dart';

class FixedAmountPayEditorWidget extends StatefulWidget {
  final AppModel app;
  static taskEditor(AppModel app, model) => FixedAmountPayEditorWidget(
        model: model,
        app: app,
      );

  final FixedAmountPayModel model;

  const FixedAmountPayEditorWidget(
      {Key? key, required this.model, required this.app})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _FixedAmountPayEditorWidgetState();
}

class _FixedAmountPayEditorWidgetState
    extends State<FixedAmountPayEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      PayTypeWidget(
        payTypeCallback: (PayTypeModel payType) {
          widget.model.paymentType = payType;
        },
        model: widget.model.paymentType,
        app: widget.app,
      ),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.amount != null
                ? widget.model.amount.toString()
                : '0.0',
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
            ),
            valueChanged: (value) {
              widget.model.amount = double_parse(value);
            },
            decoration: const InputDecoration(
              hintText: 'Amount',
              labelText: 'Amount',
            ),
          )),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.ccy ?? 'USD',
            valueChanged: (value) {
              widget.model.ccy = value;
            },
            decoration: const InputDecoration(
              hintText: 'Ccy',
              labelText: 'Ccy',
            ),
          )),
    ]);
  }
}
