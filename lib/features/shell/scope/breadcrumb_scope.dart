import 'package:cvms_desktop/core/widgets/navigation/bread_crumb_item.dart';
import 'package:flutter/material.dart';

class BreadcrumbController extends ValueNotifier<List<BreadcrumbItem>> {
  BreadcrumbController([List<BreadcrumbItem>? initial])
    : super(initial ?? const []);

  void setBreadcrumbs(List<BreadcrumbItem> breadcrumbs) {
    value = breadcrumbs;
  }
}

class BreadcrumbScope extends InheritedNotifier<BreadcrumbController> {
  const BreadcrumbScope({
    super.key,
    required BreadcrumbController controller,
    required super.child,
  }) : super(notifier: controller);

  static BreadcrumbController controllerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BreadcrumbScope>();
    final controller = scope?.notifier;
    if (controller == null) {
      throw FlutterError(
        'BreadcrumbScope.controllerOf() called with a context that does not contain a BreadcrumbScope.',
      );
    }
    return controller;
  }

  static List<BreadcrumbItem> of(BuildContext context) {
    return controllerOf(context).value;
  }
}
