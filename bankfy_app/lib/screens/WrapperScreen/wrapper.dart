import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/screens/LoginScreen/login_screen.dart';
import 'package:bankfyapp/screens/MainScreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    // initialRoute: '/',
    // routes: {
    //   // When navigating to the "/" route, build the FirstScreen widget.
    //   '/': (context) => LoginScreen(),
    //   // When navigating to the "/second" route, build the SecondScreen widget.
    //   '/main': (context) => MainScreen(),
    //   }
    // );
    final user = Provider.of<User>(context);
    
    // print(user);
    if (user == null) {
      // Regramos la pagina de login si no esta loggeado
      return LoginScreen();
    } 
    else {
      // Regresamos la pagina inicial si ya estamos loggeados
      return MainScreen();
    }
  }
}