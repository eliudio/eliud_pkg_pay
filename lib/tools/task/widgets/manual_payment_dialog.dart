import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:eliud_core/tools/widgets/dialog_helper.dart';

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
}

class _ManualPaymentDialogState extends State<ManualPaymentDialog> {
  final DialogStateHelper helper = DialogStateHelper();
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
    return helper.build(
        title: 'Manual Payment',
        contents: getFieldsWidget(context),
        buttons: helper.getYesNoButtons(
            context, () => pressed(true), () => pressed(false)));
  }

  Widget getFieldsWidget(BuildContext context) {
    return helper.fieldsWidget(context, <Widget>[
      helper.getListTile(
        leading: Icon(Icons.payment),
        title: Text('Please pay ' +
            widget.amount.toString() +
            ' ' +
            widget.ccy +
            ' to the bank account with the below details'),
        subtitle: Text('Purpose: ' + widget.purpose),
      ),
      helper.getListTile(
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
      helper.getListTile(
        leading: Icon(Icons.attach_money),
        title: Text('Bank name: ' + widget.bankName),
        subtitle: Text('Bank Identifier Code: ' + widget.bankIdentifierCode),
      ),
      Text(
          'Ones paid, please provide payment name and reference below and submit. We will then review your payment.'),
      helper.getListTile(
          leading: Icon(Icons.payment),
          title: TextFormField(
            controller: paymentReferenceController,
            decoration: const InputDecoration(
              hintText: 'Enter your Payment Reference',
              labelText: 'Payment Reference',
            ),
          )),
      helper.getListTile(
          leading: Icon(Icons.person),
          title: TextFormField(
            controller: personController,
            decoration: const InputDecoration(
              hintText: 'Enter the name of the payer',
              labelText: "Payer's name",
            ),
          )),
    ]);
  }

  void pressed(bool success) {
    Navigator.pop(context);
    widget.payedWithTheseDetails(
        paymentReferenceController.text, personController.text, success);
  }

  @override
  void dispose() {
    super.dispose();
    paymentReferenceController.dispose();
    personController.dispose();
  }
}
