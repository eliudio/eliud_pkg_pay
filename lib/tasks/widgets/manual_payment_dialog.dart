import 'package:eliud_core_main/apis/style/style_registry.dart';
import 'package:eliud_core_main/model/app_model.dart';
import 'package:flutter/material.dart';

typedef PayedWithTheseDetails = Function(
    String paymentReference, String paymentName, bool success);

class ManualPaymentDialog extends StatefulWidget {
  final AppModel app;
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
      {super.key,
      required this.app,
      this.purpose,
      this.amount,
      this.ccy,
      this.payTo,
      this.country,
      this.bankIdentifierCode,
      this.payeeIBAN,
      this.bankName,
      this.payedWithTheseDetails});

  @override
  State<ManualPaymentDialog> createState() => _ManualPaymentDialogState();
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
    return StyleRegistry.registry()
        .styleWithApp(widget.app)
        .frontEndStyle()
        .dialogWidgetStyle()
        .flexibleDialog(widget.app, context,
            includeHeading: true,
            title: 'Manual Payment',
            child: getFieldsWidget(context),
            buttons: [
          StyleRegistry.registry()
              .styleWithApp(widget.app)
              .frontEndStyle()
              .buttonStyle()
              .dialogButton(widget.app, context,
                  label: 'Cancel', onPressed: () => pressed(false)),
          StyleRegistry.registry()
              .styleWithApp(widget.app)
              .frontEndStyle()
              .buttonStyle()
              .dialogButton(widget.app, context,
                  label: 'Continue', onPressed: () => pressed(true)),
        ]);
  }

  Widget getFieldsWidget(BuildContext context) {
    return StyleRegistry.registry()
        .styleWithApp(widget.app)
        .frontEndStyle()
        .containerStyle()
        .topicContainer(widget.app, context, children: <Widget>[
      StyleRegistry.registry()
          .styleWithApp(widget.app)
          .frontEndStyle()
          .listTileStyle()
          .getListTile(
            widget.app,
            context,
            leading: Icon(Icons.payment),
            title: Text(
                'Please pay ${widget.amount} ${widget.ccy!} to the bank account with the below details'),
            subtitle: Text('Purpose: ${widget.purpose!}'),
          ),
      StyleRegistry.registry()
          .styleWithApp(widget.app)
          .frontEndStyle()
          .listTileStyle()
          .getListTile(
            widget.app,
            context,
            isThreeLine: true,
            leading: Icon(Icons.person),
            title: Text('Pay to: ${widget.payTo!}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Payee IBAN: ${widget.payeeIBAN!}'),
                Text('Country: ${widget.country!}'),
              ],
            ),
          ),
      StyleRegistry.registry()
          .styleWithApp(widget.app)
          .frontEndStyle()
          .listTileStyle()
          .getListTile(
            widget.app,
            context,
            leading: Icon(Icons.attach_money),
            title: Text('Bank name: ${widget.bankName!}'),
            subtitle:
                Text('Bank Identifier Code: ${widget.bankIdentifierCode!}'),
          ),
      Text(
          'Ones paid, please provide payment name and reference below and submit. We will then review your payment.'),
      StyleRegistry.registry()
          .styleWithApp(widget.app)
          .frontEndStyle()
          .listTileStyle()
          .getListTile(widget.app, context,
              leading: Icon(Icons.payment),
              title: TextFormField(
                controller: paymentReferenceController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Payment Reference',
                  labelText: 'Payment Reference',
                ),
              )),
      StyleRegistry.registry()
          .styleWithApp(widget.app)
          .frontEndStyle()
          .listTileStyle()
          .getListTile(widget.app, context,
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
