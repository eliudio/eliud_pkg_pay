import 'package:eliud_core/style/style_registry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PayedWithTheseDetails = Function(
    String paymentReference, String paymentName, bool success);

class ManualPaymentDialog extends StatefulWidget {
  final String? purpose;
  final double? amount;
  final String? ccy;
  final String? payTo;
  final String? country;
  final String? bankIdentifierCode;
  final String? payeeIBAN;
  final String? bankName;

  final PayedWithTheseDetails? payedWithTheseDetails;

  ManualPaymentDialog(
      {Key? key,
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
    return StyleRegistry.registry().styleWithContext(context).frontEndStyle().dialogWidgetStyle().flexibleDialog(context,
        title: 'Manual Payment',
        child: getFieldsWidget(context),
        buttons: [
          StyleRegistry.registry()
              .styleWithContext(context)
              .frontEndStyle().buttonStyle()
              .dialogButton(context,
                  label: 'Cancel', onPressed: () => pressed(true)),
          StyleRegistry.registry()
              .styleWithContext(context)
              .frontEndStyle().buttonStyle()
              .dialogButton(context,
                  label: 'Continue', onPressed: () => pressed(false)),
        ]);
  }

  Widget getFieldsWidget(BuildContext context) {
    return StyleRegistry.registry()
        .styleWithContext(context)
        .frontEndStyle().containerStyle()
        .topicContainer(context, children: <Widget>[
      StyleRegistry.registry()
          .styleWithContext(context)
          .frontEndStyle().listTileStyle()
          .getListTile(
            context,
            leading: Icon(Icons.payment),
            title: Text('Please pay ' +
                widget.amount.toString() +
                ' ' +
                widget.ccy! +
                ' to the bank account with the below details'),
            subtitle: Text('Purpose: ' + widget.purpose!),
          ),
      StyleRegistry.registry()
          .styleWithContext(context)
          .frontEndStyle().listTileStyle()
          .getListTile(
            context,
            isThreeLine: true,
            leading: Icon(Icons.person),
            title: Text('Pay to: ' + widget.payTo!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Payee IBAN: ' + widget.payeeIBAN!),
                Text('Country: ' + widget.country!),
              ],
            ),
          ),
      StyleRegistry.registry()
          .styleWithContext(context)
          .frontEndStyle().listTileStyle()
          .getListTile(
            context,
            leading: Icon(Icons.attach_money),
            title: Text('Bank name: ' + widget.bankName!),
            subtitle:
                Text('Bank Identifier Code: ' + widget.bankIdentifierCode!),
          ),
      Text(
          'Ones paid, please provide payment name and reference below and submit. We will then review your payment.'),
      StyleRegistry.registry()
          .styleWithContext(context)
          .frontEndStyle().listTileStyle()
          .getListTile(context,
              leading: Icon(Icons.payment),
              title: TextFormField(
                controller: paymentReferenceController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Payment Reference',
                  labelText: 'Payment Reference',
                ),
              )),
      StyleRegistry.registry()
          .styleWithContext(context)
          .frontEndStyle().listTileStyle()
          .getListTile(context,
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
    widget.payedWithTheseDetails!(
        paymentReferenceController.text, personController.text, success);
  }

  @override
  void dispose() {
    super.dispose();
    paymentReferenceController.dispose();
    personController.dispose();
  }
}
