import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/style/frontend/has_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum PayTypeType {
  CreditCard, Manual
}

typedef PayTypeTypeCallback = Function(
    PayTypeType payTypeType);

class PayTypeTypeWidget extends StatefulWidget {
  PayTypeTypeCallback payTypeTypeCallback;
  final PayTypeType payTypeType;
  final AppModel app;
  PayTypeTypeWidget(
      {Key? key,
        required this.app,
        required this.payTypeTypeCallback,
        required this.payTypeType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PayTypeTypeWidgetState();
  }
}

class _PayTypeTypeWidgetState extends State<PayTypeTypeWidget> {
  int? _heightTypeSelectedRadioTile;

  void initState() {
    super.initState();
    _heightTypeSelectedRadioTile = widget.payTypeType.index;
  }

  String heighttTypeLandscapeStringValue(PayTypeType? payTypeType) {
    switch (payTypeType) {
      case PayTypeType.CreditCard:
        return 'Credit card';
      case PayTypeType.Manual:
        return 'Manual payment';
    }
    return '?';
  }

  void setSelection(int? val) {
    setState(() {
      _heightTypeSelectedRadioTile = val;
      if (val == 0) {
        widget.payTypeTypeCallback(PayTypeType.CreditCard);
      } else {
        widget.payTypeTypeCallback(PayTypeType.Manual);
      }

    });
  }

  Widget getOption(PayTypeType? payTypeType) {
    if (payTypeType == null) return Text("?");
    var stringValue = heighttTypeLandscapeStringValue(payTypeType);
    return Center(
        child: radioListTile(
            widget.app,
            context,
            payTypeType.index,
            _heightTypeSelectedRadioTile,
            stringValue,
            null,
                (dynamic val) => setSelection(val)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      getOption(PayTypeType.CreditCard),
      getOption(PayTypeType.Manual)
    ], shrinkWrap: true, physics: ScrollPhysics());
  }
}
