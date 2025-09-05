import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:cvms_desktop/core/utils/custom_window_titlebar.dart';
import 'package:cvms_desktop/features/vehicle_management/windows/add_vehicle_form.dart';
import 'package:cvms_desktop/features/dashboard/windows/view_entry.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app/cvms_app.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // only initialize firebase in main window
  if (args.isEmpty || args.first != 'multi_window') {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argsMap =
        args[2].isEmpty ? {} : jsonDecode(args[2]) as Map<String, dynamic>;

    final controller = WindowController.fromWindowId(windowId);
    final type = argsMap['type'] as String?;

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            type == 'viewEntry'
                ? ViewEntryPage(windowController: controller, args: argsMap)
                : AddVehicleFormPage(
                  windowController: controller,
                  args: argsMap,
                ),
      ),
    );
  } else {
    runApp(const CVMSApp());
    initializeWindowProperties(
      initialSize: const Size(1280, 720),
      minSize: const Size(1280, 720),
      alignment: Alignment.center,
    );
  }
}
