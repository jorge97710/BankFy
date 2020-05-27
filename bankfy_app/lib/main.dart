import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/WrapperScreen/wrapper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static var navigatorKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('es', 'GT')
        ],
        home: Wrapper(),
      ),
    );
  }
}