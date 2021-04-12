import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'dart:js' as js;

import 'package:flutter/material.dart';

import '../payment_platform.dart';

import 'dart:html';

class WebStripeElements extends StatefulWidget {
  final HandlePayment? handlePayment;
  final String? ccy;
  final String? name;
  final int? cents;

  const WebStripeElements({Key? key, this.ccy, this.name, this.cents, this.handlePayment}) : super(key: key);

  @override
  _WebStripeElementsState createState() => _WebStripeElementsState();
}

class _WebStripeElementsState extends State<WebStripeElements> {
  late Widget _iframeWidget;

  final IFrameElement _iframeElement = IFrameElement();

  final _textController = TextEditingController();

  @override
  void initState() {
    debugPrint("init state");
    super.initState();

    _iframeElement.height = '150';
    _iframeElement.width = '400';

    debugPrint("Uri.base.host: " + Uri.base.host);
    debugPrint("widget.name: " + widget.name!);
    debugPrint("stripe_ccy.name: " + widget.ccy!);
    _iframeElement.src = 'https://' + Uri.base.host  + '?stripe_amount=' + widget.cents.toString() + '&stripe_ccy=' + widget.ccy! + '&stripe_name=' + widget.name!;
    _iframeElement.style.border = 'none';

    js.context['flutter_feedback'] = (msg) {
      Map<String, dynamic> feedback = jsonDecode(msg);
      Map<String, dynamic>? paymentIntent = feedback['paymentIntent'];
      if (paymentIntent == null) {
        widget.handlePayment!(PaymentFailure('paymentIntent is null', msg));
      } else {
        String? status = paymentIntent['status'];
        if (status == 'succeeded') {
          String? id = paymentIntent['id'];
          widget.handlePayment!(PaymentSucceeded(id));
        } else {
          widget.handlePayment!(PaymentFailure(status, msg));
        }
      }
      Navigator.of(context).pop();
    };

    debugPrint("register");
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    return  _iframeWidget;
 }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
