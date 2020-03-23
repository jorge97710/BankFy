import 'package:bankfyapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bankfyapp/utilities/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _MainScreenState extends State<MainScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    //final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: 
        Text(
          'Bankfy - Bienvenido ',
          style: TextStyle(
            color: Colors.black  
          ),
        ),
        backgroundColor: Color(0xFF00AB08),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Salir'),
              onPressed: () async {
                await _auth.signOut();
              },
            )
        ],
      ),
    );
  }
}