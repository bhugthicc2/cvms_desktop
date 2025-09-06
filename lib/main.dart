import 'package:cvms_desktop/core/utils/custom_window_titlebar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app/cvms_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CVMSApp());
  initializeWindowProperties(
    initialSize: const Size(1280, 720),
    minSize: const Size(1280, 720),
    alignment: Alignment.center,
  );
}
