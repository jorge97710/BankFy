import 'package:bankfyapp/screens/EstadisticasScreen/estadisticas_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:bankfyapp/screens/BancosScreen/bancos_screen.dart';
import 'package:bankfyapp/screens/CamaraScreen/camara_screen.dart';
import 'package:bankfyapp/screens/ContactScreen/contact_screen.dart';
import 'package:bankfyapp/screens/BudgetPlannerScreen/budget_planner_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final nombreUsuario = TextEditingController();
  bool revision = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      obtenerDatos(Provider.of<User>(context, listen: false));
    });
  }

  // Widget que define dos botones de redireccionamiento a una ruta especificada cada uno
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route
              )
            );
            //Navigator.pop(context);
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

  // Widget que define un boton de redireccionamiento a una ruta especificada
  Widget _buildBotonOpcion2(StatefulWidget route, Icon icon, String texto) {
    return GestureDetector(
      child: Container(
        height: 120.0,
        width: 250.0,
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route
              )
            );
            //Navigator.pop(context);
          },
          padding: EdgeInsets.all(25.0),
          child: Column( 
            children: <Widget>[
              icon,
              Text(
                texto,
                style: new TextStyle(
                  // fontSize: 10.0,
                  // color: Colors.yellow,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // Widget que define un contenedor con capacidad de 2 botones horizontales
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

  // Widget que define un contenedor para un unico boton horizontal
  Widget  _buildOptionButtonsContainer2(StatefulWidget route, Icon icon, String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBotonOpcion2(
            route,
            icon,
            texto
          ),
        ],
      ),
    );
  }

  Future obtenerDatos(user) async {
    var datos = await DatabaseService(uid: user.uid).getUserData();
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (datos != null) {
      if (datos.data != null){
        if (datos.data['nombre'] != null){
          setState(() {
            nombreUsuario.text = datos.data['nombre'].toString(); 
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<User>(context);
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
              // Navigator.pop(context);
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
            'Bienvenido',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
                      BudgetPlannerScreen(),
                      Icon(
                        Icons.monetization_on,
                        size: 45.0,
                      ),
                      'Presupuesto',
                      EstadisticasScreen(),
                      Icon(
                        Icons.poll,
                        size: 45.0,
                      ),
                      'Estadísticas'
                    ),
                    _buildOptionButtonsContainer2(
                      CamaraScreen(),
                      Icon(
                        Icons.party_mode,
                        size: 50.0,
                      ),
                      'Scaneo de Facturas'
                    ),
                    _buildOptionButtonsContainer(
                      BancosScreen(),
                      Icon(
                        //Icons.store,
                        Icons.local_atm,
                        size: 45.0,
                      ),
                      'Bancos',
                      ContactScreen(),
                      Icon(
                        Icons.room,
                        size: 45.0,
                      ),
                      'Consultas'
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