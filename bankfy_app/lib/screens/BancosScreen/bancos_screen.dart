import 'package:bankfyapp/screens/LoginScreen/login_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BancosScreen extends StatefulWidget {
  @override
  _BancosScreenState createState() => _BancosScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _BancosScreenState extends State<BancosScreen> {
  final AuthService _auth = AuthService();

  // Widget que define el componente para hacer Login con Google
  Widget _buildBotonOpcion(StatefulWidget route, Icon icon, String texto) {
    return GestureDetector(
      child: Container(
        height: 120.0,
        width: 120.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green[500],
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          // image: DecorationImage(
          //   image: logo,
          // )
        ),
        child: FlatButton(
          onPressed: () async {
            //await _auth.signOut();
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => route
            //   )
            // );
            //Navigator.pop(context);
            print('Banco 1');
          },
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: <Widget>[
              icon,
              Text(
                texto,
                style: new TextStyle(
                  fontSize: 11.0,
                  // color: Colors.yellow,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget que define el componente para Login con Google
  Widget  _buildOptionButtonsContainer(StatefulWidget route, Icon icon, String texto, StatefulWidget route2, Icon icon2, String texto2) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBotonOpcion(
            route,
            icon,
            texto,
          ),
          _buildBotonOpcion(
            route2,
            icon2,
            texto2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    // final user = Provider.of<User>(context);
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) { 
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Salir'),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              //Navigator.pop(context);
            },
          ), 
        );
      });
    }

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().datos,
        child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text(
            'Bancos',
            style: TextStyle(
              color: Colors.black, 
            ),
          ),
          backgroundColor: Color(0xFF149414),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.settings),
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              label: Text(''),
              onPressed: () => _showSettingsPanel(),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildOptionButtonsContainer(
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'BAC',
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'G&T'
                    ),
                    _buildOptionButtonsContainer(
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'Banrural',
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'Industrial'
                    ),
                    _buildOptionButtonsContainer(
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        //Icons.local_atm,
                        size: 45.0,
                      ),
                      'Bantrab',
                      LoginScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'Promerica'
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}