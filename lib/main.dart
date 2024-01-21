import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:socio_chat/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socio_chat/dep_inj/dpendency_injector.dart' as inj;
import 'firebase_options.dart';

Future<void> initApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await inj.init();
  inj.setupServiceLocator();
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await initApp();
      FlutterNativeSplash.remove();
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );
      runApp(const ChatApp());
    },
    (error, stack) {
      /* FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true, 
    ); */
    },
  );  
}
