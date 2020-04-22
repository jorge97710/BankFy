import 'package:bankfyapp/screens/ConfiguracionPresupuestoScreen/configuracion_presupuesto_screen.dart';
import 'package:bankfyapp/screens/VistaPresupuestoScreen/vista_presupuesto_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPlannerScreen extends StatefulWidget {
  @override
  _BudgetPlannerScreenState createState() => _BudgetPlannerScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _BudgetPlannerScreenState extends State<BudgetPlannerScreen> {
  final AuthService _auth = AuthService();

  // Widget que define un boton de redireccionamiento a una ruta especificada
  Widget _buildBotonOpcion(StatefulWidget route, Icon icon, String texto) {
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

  // Widget que define un contenedor para un unico boton horizontal
  Widget  _buildOptionButtonsContainer(StatefulWidget route, Icon icon, String texto) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBotonOpcion(
            route,
            icon,
            texto
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
            'Planificador de presupuesto',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
                  vertical: 50.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildOptionButtonsContainer(
                      VistaPresupuestoScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'Presupuesto',
                    ),
                    _buildOptionButtonsContainer(
                      ConfiguracionPresupuestoScreen(),
                      Icon(
                        Icons.store,
                        size: 45.0,
                      ),
                      'Configurar presupuesto'
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