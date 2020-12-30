import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eliud_core/core/navigate/navigate_bloc.dart';
import 'package:eliud_core/core/navigate/navigation_event.dart';
import 'package:eliud_core/model/app_bar_component_state.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/member_subscription_model.dart';
import 'package:eliud_core/tools/main_abstract_repository_singleton.dart';
import 'package:eliud_core/tools/random.dart';
import 'package:eliud_pkg_pay/tools/bloc/payment_event.dart';
import 'package:eliud_pkg_pay/tools/bloc/payment_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:eliud_core/core/access/bloc/access_event.dart';
import 'package:eliud_core/core/access/bloc/access_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc(): super(UninitializedPaymentState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is InitPaymentEvent) {
      yield InitializedPaymentState(event.ccy, event.amount, event.orderNumber);
    }
  }

}
