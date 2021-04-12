import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'payment_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class MobilePaymentPlatform extends AbstractPaymentPlatform {
  final bool? requiresConfirmation;

  MobilePaymentPlatform({this.requiresConfirmation});

  final HttpsCallable INTENT = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');

  @override
  void startPaymentProcess(BuildContext? context, HandlePayment handlePayment, String? name, String? ccy, double? amount) {
    var cents = (amount! * 100).toInt();
    StripePayment.setOptions(StripeOptions(
        publishableKey: 'pk_test_51GxyTUCM4yYbbMk8IvFWz65Lp5aCXN16iZcQsr0Z1VYQPlrwe7GhoJ4ZTdF571VYTzOrzHAvr0Q5LKdTCZ3naaYo00T4RFwif7',
        androidPayMode: 'test'));

    var prefilledInformation  = PrefilledInformation(
        billingAddress: BillingAddress(
        ));
    var options = CardFormPaymentRequest(requiredBillingAddressFields: 'full', prefilledInformation: prefilledInformation);

    StripePayment.paymentRequestWithCardForm(options)
        .then((paymentMethod) {
      var amount = cents.toDouble();
      INTENT.call(<String, dynamic>{'amount': amount,'currency':ccy}).then((response) {
        confirmDialog(context, response.data['client_secret'], paymentMethod, handlePayment, ccy, amount); //function for confirmation for payment
      });
    });
  }

  void confirmDialog(BuildContext? context, String? clientSecret, PaymentMethod paymentMethod, HandlePayment handlePayment, String? ccy, double amount) {
    if ((requiresConfirmation != null) && requiresConfirmation!) {
      var confirm = AlertDialog(
        title: Text('Confirm Payement'),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Make Payment',
                // style: TextStyle(fontSize: 25),
              ),
              Text('Charge amount:' + amount.toString() + " " + ccy!)
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context!).pop();
              final snackBar = SnackBar(content: Text('Payment Cancelled'),);
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
          RaisedButton(
            child: Text('Confirm'),
            onPressed: () {
              Navigator.of(context!).pop();
              confirmPayment(clientSecret, paymentMethod,
                handlePayment,); // function to confirm Payment
            },
          ),
        ],
      );
      showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return confirm;
          });
    } else {
      confirmPayment(clientSecret, paymentMethod,
        handlePayment,); // function to confirm Payment
    }
  }

  void confirmPayment(String? sec, PaymentMethod paymentMethod, HandlePayment handlePayment) {
    StripePayment.confirmPaymentIntent(
      PaymentIntent(clientSecret: sec, paymentMethodId: paymentMethod.id),
    ).then((val) {
      if (val.status == 'succeeded') {
        handlePayment(PaymentSucceeded(val.paymentIntentId));
      } else {
        handlePayment(PaymentFailure(val.status, jsonEncode(val.toJson())));
      }
    }).catchError((onError) {
      handlePayment(PaymentFailure(onError, ''));
    });
  }
}
