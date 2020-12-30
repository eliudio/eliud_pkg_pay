import 'package:equatable/equatable.dart';

class PaymentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPaymentEvent extends PaymentEvent {
  final String ccy;
  final double amount;
  final String orderNumber;

  InitPaymentEvent(this.ccy, this.amount, this.orderNumber);

  @override
  List<Object> get props => [ccy, amount, orderNumber];
}
