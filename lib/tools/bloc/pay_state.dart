import 'package:eliud_core/model/abstract_repository_singleton.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/dialog_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/model/menu_item_model.dart';
import 'package:eliud_core/model/page_model.dart';
import 'package:eliud_core/tools/action/action_model.dart';
import 'package:eliud_core/tools/common_tools.dart';
import 'package:eliud_core/tools/merge.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:eliud_core/core/access/bloc/access_event.dart';

abstract class PayState extends Equatable {
}

class UninitializedPayState extends PayState {
  @override
  List<Object> get props => [];
}

class InitializedPayState extends PayState {
  final String ccy;
  final double amount;
  final String orderNumber;

  InitializedPayState(this.ccy, this.amount, this.orderNumber);

  @override
  List<Object> get props => [ccy, amount, orderNumber];
}

