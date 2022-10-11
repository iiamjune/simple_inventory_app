import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/generated_routes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'constants/labels.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final RouteGenerate _routeGenerate = RouteGenerate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _routeGenerate.router.routeInformationParser,
      routeInformationProvider: _routeGenerate.router.routeInformationProvider,
      routerDelegate: _routeGenerate.router.routerDelegate,
      title: Label.appName,
      debugShowCheckedModeBanner: true,
      builder: EasyLoading.init(
        builder: (context, child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1),
            child: child!,
          );
        },
      ),
    );
  }
}
