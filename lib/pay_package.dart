import 'package:eliud_core/core/access/bloc/access_bloc.dart';
import 'package:eliud_core/core/navigate/navigate_bloc.dart';
import 'package:eliud_core/eliud.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/package/package.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_entity.dart';
import 'package:eliud_pkg_pay/tools/task/pay_task_model.dart';
import 'package:eliud_pkg_pay/tools/task/review_and_ship_task_entity.dart';
import 'package:eliud_pkg_pay/tools/task/review_and_ship_task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:eliud_core/model/access_model.dart';

abstract class PayPackage extends Package {
  @override
  BlocProvider? createMainBloc(NavigatorBloc navigatorBloc, AccessBloc accessBloc) => null;

  @override
  Future<bool?> isConditionOk(String packageCondition, AppModel app, MemberModel? member, bool isOwner, bool? isBlocked, PrivilegeLevel? privilegeLevel) => Future.value(null);

  @override
  List<String>? retrieveAllPackageConditions() => null;

  @override
  void init() {
    TaskModelRegistry.registry()!.addMapper(FixedAmountPayEntity.label, FixedAmountPayModelMapper());
    TaskModelRegistry.registry()!.addMapper(ContextAmountPayEntity.label, ContextAmountPayModelMapper());
    TaskModelRegistry.registry()!.addMapper(ReviewAndShipTaskEntity.label, ReviewAndShipTaskModelMapper());
  }

  @override
  List<MemberCollectionInfo>? getMemberCollectionInfo() => null;
}
