import 'package:equatable/equatable.dart';

abstract class PayState extends Equatable {
}

class UninitializedPayState extends PayState {
  @override
  List<Object> get props => [];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is InitializedPayState &&
              runtimeType == other.runtimeType;
}

class InitializedPayState extends PayState {
  final String ccy;
  final double amount;
  final String orderNumber;

  InitializedPayState(this.ccy, this.amount, this.orderNumber);

  @override
  List<Object> get props => [ccy, amount, orderNumber];

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is InitializedPayState &&
              runtimeType == other.runtimeType &&
              ccy == other.ccy &&
              amount == other.amount &&
              orderNumber == other.orderNumber;
}

