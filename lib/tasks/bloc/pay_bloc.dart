import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eliud_pkg_pay/tasks/bloc/pay_event.dart';
import 'package:eliud_pkg_pay/tasks/bloc/pay_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayBloc extends Bloc<PayEvent, PayState> {
  PayBloc() : super(UninitializedPayState()) {
    on<InitPayEvent>((event, emit) {
      emit(InitializedPayState(event.ccy, event.amount, event.orderNumber));
    });
  }
}
