import 'package:equatable/equatable.dart';

class PayEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitPayEvent extends PayEvent {
  final String ccy;
  final double amount;
  final String orderNumber;

  InitPayEvent(this.ccy, this.amount, this.orderNumber);

  @override
  List<Object> get props => [ccy, amount, orderNumber];
}
