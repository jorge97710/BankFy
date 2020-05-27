import 'package:bankfyapp/screens/EstadisticasScreen/estadisticas_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:bankfyapp/screens/BancosScreen/bancos_screen.dart';
import 'package:bankfyapp/screens/CamaraScreen/camara_screen.dart';
import 'package:bankfyapp/screens/ContactScreen/contact_screen.dart';
import 'package:bankfyapp/screens/BudgetPlannerScreen/budget_planner_screen.dart';
import 'package:bankfyapp/screens/VistaPresupuestoScreen/vista_presupuesto_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

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
  final notifications = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      obtenerDatos(Provider.of<User>(context, listen: false));
    });

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => onSelectedNotification(payload)
    );

    notifications.initialize(
      InitializationSettings(settingsAndroid, settingsIOS),
      onSelectNotification: onSelectedNotification
    );
  }

  Future onSelectedNotification(String payload) async => await MyApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) => VistaPresupuestoScreen()));

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
  Widget _buildBotonOpcion2(StatefulWidget route, Icon icon, String texto, user) {
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
            var budget = await DatabaseService(uid: user.uid).getPresupuestoData();
            if (budget != null) {
              if (budget.data != null){
                if (budget.data['presupuesto'] != null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => route
                    )
                  );                
                }
                else{
                  _showErrorSetPresupuesto();
                }
              }
              else{
                _showErrorSetPresupuesto();
              }
            }
            else{
              _showErrorSetPresupuesto();
            }
            //await _auth.signOut();
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

  
  _showErrorSetPresupuesto() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Error - Presupuesto no configurado"),
        content: new Text("Primero debes tener un presupuesto configurado (Ir a Presupuesto -> Configuración de presupuesto)"),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
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
  Widget  _buildOptionButtonsContainer2(StatefulWidget route, Icon icon, String texto, user) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBotonOpcion2(
            route,
            icon,
            texto,
            user
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

  Future revisarPresupuestoParaCerrar(user) async {
    var budget = await DatabaseService(uid: user.uid).getPresupuestoData();
    var gast = await DatabaseService(uid: user.uid).getGastosData(); 
    var monts = await DatabaseService(uid: user.uid).getMontosGastosData(); 
    if (budget != null && gast != null && monts != null) {
      if (budget.data != null && gast.data != null && monts.data != null){
        if (budget.data['presupuesto'] != null && gast.data['gasto'] != null){
          // Guardar los datos para el historial
          var fecha = new DateTime.now();
          var format = DateFormat("dd-MM-yyyy", "es_GT");
          String fechaString = format.format(fecha);
          String fechaLimiteString = budget.data['fecha_final']; 
          Map<String, dynamic> montadera;

          if (!(DateFormat("dd-MM-yyyy", "es_GT").parse(fechaLimiteString).isAfter(DateFormat("dd-MM-yyyy", "es_GT").parse(fechaString)))){
            var contador = 0;
            double porcentajeLimite;
            double gastoLimite;
            double gastoUtilizado;
            String gastosHechos;
            double cantidadRestante = 0.0; // = 100;
            var fechaFinal = fechaLimiteString;
            var gastos = []; // = ['Comida', 'Ropa'];
            var montosRestantes = []; // = [45, 55];

            // Procesamiento para historial
            var cantidadInicial = budget.data['presupuesto'];
            var gastadera = [];
            var porcentajedera = [];
            for(var gastar in gast.data['gasto']){
              gastadera.add(gastar);
            }
            for(var porcentaj in gast.data['porcentaje']){
              porcentajedera.add(porcentaj);
            } 

            montadera = monts.data;

            montadera.forEach((k,v) => {
              porcentajeLimite = porcentajedera[contador],
              gastosHechos = gastadera[contador],
              gastoLimite = double.parse(cantidadInicial.toString()) * (porcentajeLimite / 100.0),
              gastoUtilizado = double.parse(v),
              montosRestantes.add(gastoLimite - gastoUtilizado),
              gastos.add(gastosHechos),          
              contador++
            });

            for (var i in montosRestantes){
              cantidadRestante = cantidadRestante + i;
            }

            // fechaFinal = '20-05-2020';
            await DatabaseService(uid: user.uid).updateHistorialResiduoData(fechaFinal, cantidadRestante.toStringAsFixed(2));
            await DatabaseService(uid: user.uid).updateHistorialGastosData(fechaFinal, gastos);
            await DatabaseService(uid: user.uid).updateHistorialMontosData(fechaFinal, montosRestantes);

            // Eliminar los registros del presupuesto actual
            await DatabaseService(uid: user.uid).deletePresupuestoData();
            await DatabaseService(uid: user.uid).deleteGastosData();
            await DatabaseService(uid: user.uid).deleteMontosGastosData();
          }
        }
        else {
        }  
      }
      else {
      }
    }
    else {
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

    if (revision) {
      // Se revisa cada vez que se pasa por esta Screen
      revisarPresupuestoParaCerrar(user);
      revision = false;
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
                      'Scaneo de Facturas',
                      user
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