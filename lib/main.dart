import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'features/splash/splash_screen.dart';
import 'state/app_state.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const StudyApp(),
    ));

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'مذاكرتي',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        locale: const Locale('ar'), // يفرض RTL تلقائيًا على كل الشاشات
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const SplashScreen(),
      );
}
