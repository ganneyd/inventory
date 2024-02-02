import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/dependency_check/app.dart';
import 'package:inventory_v1/service_locator.dart';
import 'package:logging/logging.dart';

void main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) {
    print('${record.level.name}: ${record.loggerName}: ${record.message}');
  });

  await initDependencies();
  runApp(const App());
}
