import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eliud_pkg_pay/tools/bloc/pay_event.dart';
import 'package:eliud_pkg_pay/tools/bloc/pay_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc(): super(UninitializedPayState());

  @override
  Stream<PayState> mapEventToState(PayEvent event) async* {
    if (event is InitPayEvent) {
      yield InitializedPayState(event.ccy, event.amount, event.orderNumber);
    }
  }

}
