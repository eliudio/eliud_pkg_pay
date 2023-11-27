import 'package:eliud_core_main/apis/style/frontend/has_list_tile.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum PayTypeType { creditCard, manual }

typedef PayTypeTypeCallback = Function(PayTypeType payTypeType);

class PayTypeTypeWidget extends StatefulWidget {
  final PayTypeTypeCallback payTypeTypeCallback;
  final PayTypeType payTypeType;
  final AppModel app;

  PayTypeTypeWidget(
      {super.key,
      required this.app,
      required this.payTypeTypeCallback,
      required this.payTypeType});

  @override
  State<StatefulWidget> createState() {
    return _PayTypeTypeWidgetState();
  }
}

class _PayTypeTypeWidgetState extends State<PayTypeTypeWidget> {
  int? _heightTypeSelectedRadioTile;

  @override
  void initState() {
    super.initState();
    _heightTypeSelectedRadioTile = widget.payTypeType.index;
  }

  String heighttTypeLandscapeStringValue(PayTypeType? payTypeType) {
    switch (payTypeType) {
      case PayTypeType.creditCard:
        return 'Credit card';
      case PayTypeType.manual:
        return 'Manual payment';
      case null:
        break;
    }
    return '?';
  }

  void setSelection(int? val) {
    setState(() {
      _heightTypeSelectedRadioTile = val;
      if (val == 0) {
        widget.payTypeTypeCallback(PayTypeType.creditCard);
      } else {
        widget.payTypeTypeCallback(PayTypeType.manual);
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
      getOption(PayTypeType.creditCard),
      getOption(PayTypeType.manual)
    ], shrinkWrap: true, physics: ScrollPhysics());
  }
}
