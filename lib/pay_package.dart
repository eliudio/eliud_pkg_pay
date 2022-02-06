import 'package:eliud_core/core/blocs/access/access_bloc.dart';
import 'package:eliud_core/eliud.dart';
import 'package:eliud_core/model/app_model.dart';
import 'package:eliud_core/model/member_model.dart';
import 'package:eliud_core/package/package.dart';
import 'package:eliud_pkg_notifications/model/abstract_repository_singleton.dart';
import 'package:eliud_pkg_pay/tasks/creditcard_pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/fixed_amount_pay_editor_widget.dart';
import 'package:eliud_pkg_pay/tasks/pay_task_entity.dart';
import 'package:eliud_pkg_pay/tasks/pay_type_model.dart';
import 'package:eliud_pkg_pay/tasks/pay_task_model.dart';
import 'package:eliud_pkg_pay/tasks/review_and_ship_task_model.dart';
import 'package:eliud_pkg_pay/tasks/review_and_ship_task_model_mapper.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model.dart';
import 'package:eliud_pkg_workflow/tools/task/task_model_registry.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:eliud_core/model/access_model.dart';

import 'tasks/context_amount_pay_model.dart';
import 'tasks/context_amount_pay_model_mapper.dart';
import 'tasks/fixed_amount_pay_model.dart';
import 'tasks/fixed_amount_pay_model_mapper.dart';

abstract class PayPackage extends Package {
  PayPackage() : super('eliud_pkg_pay');

  @override
  Future<List<PackageConditionDetails>>? getAndSubscribe(AccessBloc accessBloc, AppModel app, MemberModel? member, bool isOwner, bool? isBlocked, PrivilegeLevel? privilegeLevel) => null;

  @override
  Future<bool?> isConditionOk(AccessBloc accessBloc, String pluginCondition, AppModel app, MemberModel? member, bool isOwner, bool? isBlocked, PrivilegeLevel? privilegeLevel) async  =>
      Future.value(null);

  @override
  List<String>? retrieveAllPackageConditions() => null;

  @override
  void init() {
    TaskModelRegistry.registry()!.addTask(
        identifier: FixedAmountPayModel.label,
        definition: FixedAmountPayModel.definition,
        mapper: FixedAmountPayModelMapper(),
        editor: (app, model) => FixedAmountPayEditorWidget(app: app, model: model),
        createNewInstance: () => FixedAmountPayModel(
            identifier: FixedAmountPayModel.label,
            description: 'Fixed amount to be paid with card',
            executeInstantly: true,
            paymentType: CreditCardPayTypeModel()));
    TaskModelRegistry.registry()!.addTask(
        identifier: ContextAmountPayModel.label,
        definition: ContextAmountPayModel.definition,
        mapper: ContextAmountPayModelMapper(),
        createNewInstance: () => ContextAmountPayModel(
            identifier: ContextAmountPayModel.label,
            description: 'Amount determined by context and to be paid by card',
            executeInstantly: true,
            paymentType: CreditCardPayTypeModel()));
    TaskModelRegistry.registry()!.addTask(
        identifier: ReviewAndShipTaskModel.label,
        definition: ReviewAndShipTaskModel.definition,
        mapper: ReviewAndShipTaskModelMapper(),
        createNewInstance: () => ReviewAndShipTaskModel(
            identifier: ReviewAndShipTaskModel.label,
            description: 'Review and ship', executeInstantly: true));
  }

  @override
  List<MemberCollectionInfo> getMemberCollectionInfo() =>
      AbstractRepositorySingleton.collections;
}
