import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PayedWithTheseDetails = Function(
    String paymentReference, String paymentName, bool success);

class ManualPaymentDialog extends StatefulWidget {
  final String purpose;
  final double amount;
  final String ccy;
  final String payTo;
  final String country;
  final String bankIdentifierCode;
  final String payeeIBAN;
  final String bankName;
  final PayedWithTheseDetails payedWithTheseDetails;

  ManualPaymentDialog(
      {Key key,
      this.purpose,
      this.amount,
      this.ccy,
      this.payTo,
      this.country,
      this.bankIdentifierCode,
      this.payeeIBAN,
      this.bankName,
      this.payedWithTheseDetails})
      : super(key: key);

  @override
  _ManualPaymentDialogState createState() => _ManualPaymentDialogState();

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.9;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.9;

  static void openIt(BuildContext context, Widget dialog) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              width: width(context), height: height(context), child: dialog);
        });
  }
}

class _ManualPaymentDialogState extends State<ManualPaymentDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController paymentReferenceController =
      TextEditingController();
  final TextEditingController personController = TextEditingController();

  @override
  void initState() {
    super.initState();
    paymentReferenceController.addListener(_onPaymentReferenceChanged);
    personController.addListener(_onPersonChanged);
  }

  void _onPaymentReferenceChanged() {}

  void _onPersonChanged() {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Form(key: _formKey, child: titleAndFields(context));
  }

  Widget titleAndFields(context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          Center(
              child: Text('Manual Payment',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
          Divider(height: 10, color: Colors.red,),
          fields(context),
          Divider(height: 10, color: Colors.red,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              FlatButton(
                  onPressed: () => pressed(false),
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () => pressed(true),
                  child: Text('Continue')),
            ],
          ),
        ]);
  }

  void pressed(bool success) {
    Navigator.pop(context);
    widget.payedWithTheseDetails(
        paymentReferenceController.text, personController.text, success);
  }

  Widget fields(context) {
    return Container(
        height: ManualPaymentDialog.height(context) -
            150 /* minus the size of the button, title and divider */,
        width: ManualPaymentDialog.width(context),
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Please pay ' +
                    widget.amount.toString() +
                    ' ' +
                    widget.ccy +
                    ' to the bank account with the below details'),
                subtitle: Text('Purpose: ' + widget.purpose),
              ),
              ListTile(
                isThreeLine: true,
                leading: Icon(Icons.person),
                title: Text('Pay to: ' + widget.payTo),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Payee IBAN: ' + widget.payeeIBAN),
                    Text('Country: ' + widget.country),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Bank name: ' + widget.bankName),
                subtitle:
                    Text('Bank Identifier Code: ' + widget.bankIdentifierCode),
              ),
              Text(
                  'Ones paid, please provide payment name and reference below and submit. We will then review your payment.'),
              ListTile(
                  leading: Icon(Icons.payment),
                  title: TextFormField(
                    controller: paymentReferenceController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Payment Reference',
                      labelText: 'Payment Reference',
                    ),
                  )),
              ListTile(
                  leading: Icon(Icons.person),
                  title: TextFormField(
                    controller: personController,
                    decoration: const InputDecoration(
                      hintText: 'Enter the name of the payer',
                      labelText: "Payer's name",
                    ),
                  )),
            ]));
  }

  @override
  void dispose() {
    super.dispose();
    paymentReferenceController.dispose();
    personController.dispose();
  }
}
