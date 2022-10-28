import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_container.dart';
import 'package:eliud_core/style/frontend/has_dialog_field.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:eliud_core/tools/helpers/parse_helper.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_model.dart';
import 'package:flutter/material.dart';

import '../pay_type_types/manual_pay_type_model.dart';

typedef ManualPayTypeCallback = Function(
    ManualPayTypeModel payType);

class ManualPayTypeWidget extends StatefulWidget {
  final ManualPayTypeCallback payTypeCallback;
  final AppModel app;
  final ManualPayTypeModel model;

  const ManualPayTypeWidget(
      {Key? key, required this.payTypeCallback, required this.model, required this.app})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManualPayTypeWidgetState();
}

class _ManualPayTypeWidgetState
    extends State<ManualPayTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: ScrollPhysics(), children: [
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.payTo ?? '',
            valueChanged: (value) {
              widget.model.payTo = value;
              widget.payTypeCallback(widget.model);
            },
            decoration: const InputDecoration(
              hintText: 'Pay to',
              labelText: 'Pay to',
            ),
          )),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.country ?? '',
            valueChanged: (value) {
              widget.model.country = value;
              widget.payTypeCallback(widget.model);
            },
            decoration: const InputDecoration(
              hintText: 'Country',
              labelText: 'Country',
            ),
          )),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.bankIdentifierCode ?? '',
            valueChanged: (value) {
              widget.model.bankIdentifierCode = value;
              widget.payTypeCallback(widget.model);
            },
            decoration: const InputDecoration(
              hintText: 'Bank Identifier Code',
              labelText: 'Bank Identifier Code',
            ),
          )),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.payeeIBAN ?? '',
            valueChanged: (value) {
              widget.model.payeeIBAN = value;
              widget.payTypeCallback(widget.model);
            },
            decoration: const InputDecoration(
              hintText: 'Payee IBAN',
              labelText: 'Payee IBAN',
            ),
          )),
      getListTile(context, widget.app,
          leading: Icon(Icons.description),
          title: dialogField(
            widget.app,
            context,
            initialValue: widget.model.bankName ?? '',
            valueChanged: (value) {
              widget.model.bankName = value;
              widget.payTypeCallback(widget.model);
            },
            decoration: const InputDecoration(
              hintText: 'Bank Name',
              labelText: 'Bank Name',
            ),
          )),
    ]);
  }
}
