import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/localization/generated/app_localizations.dart';
import 'common/network/local_storage_service.dart';
import 'features/widgets/presentation/view/clock_widget_screen.dart';
import 'app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('[Dart main] args: $args');
  final isClockWidget = args.any((arg) => arg.contains('widget-type=clock'));
  debugPrint('[Dart main] isClockWidget: $isClockWidget');

  if (isClockWidget) {
    runApp(const ClockWidgetApp());
  } else {
    await LocalStorageService.init();
    runApp(const F1App());
  }
}

class ClockWidgetApp extends StatelessWidget {
  const ClockWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ClockWidgetScreen(),
    );
  }
}