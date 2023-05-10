import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_types/pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/widgets/pay_type_widget.dart';
import 'package:flutter/material.dart';

import '../context_amount_pay_model.dart';

class ContextAmountPayEditorWidget extends StatefulWidget {
  final AppModel app;
  static taskEditor(AppModel app, model) => ContextAmountPayEditorWidget(
        model: model,
        app: app,
      );

  final ContextAmountPayModel model;

  const ContextAmountPayEditorWidget(
      {Key? key, required this.model, required this.app})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContextAmountPayEditorWidgetState();
}

class _ContextAmountPayEditorWidgetState
    extends State<ContextAmountPayEditorWidget> {
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
      checkboxListTile(widget.app, context, 'Execute Instantly',
          widget.model.executeInstantly, (value) {
            setState(() {
              widget.model.executeInstantly = value ?? false;
            });
          }),
    ]);
  }
}
