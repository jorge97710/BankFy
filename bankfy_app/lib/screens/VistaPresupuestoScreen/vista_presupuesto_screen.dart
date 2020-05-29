import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getflutter/getflutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:bankfyapp/utilities/constants.dart';

class VistaPresupuestoScreen extends StatefulWidget {
  @override
  _VistaPresupuestoScreenState createState() => _VistaPresupuestoScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _VistaPresupuestoScreenState extends State<VistaPresupuestoScreen> {
  final AuthService _auth = AuthService();
  List _gastos;
  List<double> _porcentajes;
  String presupuesto1;
  List _colores = [];
  List _porcentajesUsados;
  List _gastadoActualmente;
  List _gastoLimite;
  Map<String, dynamic> _montosGastos;

  bool revision = true;

  @override
  void initState() {
    _gastos = [];
    _porcentajes = [];
    _porcentajesUsados = [];
    _gastadoActualmente = [];
    _gastoLimite = [];
    presupuesto1 = '0';
    super.initState();
    Future.delayed(Duration.zero,() {
      obtenerMontosGastos(Provider.of<User>(context, listen: false));
      obtenerGastos(Provider.of<User>(context, listen: false));
      obtenerPresupuesto(Provider.of<User>(context, listen: false));
    });
  }

  Future obtenerGastos(user) async {
    var gastos = await DatabaseService(uid: user.uid).getGastosData(); 
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (gastos != null) {
      if (gastos.data != null){
        if (gastos.data['gasto'] != null){
          setState(() {
            for( var gasto in gastos.data['gasto']){
              _gastos.add(gasto);
            }
            for( var porcentaje in gastos.data['porcentaje']){
              _porcentajes.add(porcentaje);
            }        
          });
        }
      }
    }
  }

  Future obtenerPresupuesto(user) async {
    var presupuesto = await DatabaseService(uid: user.uid).getPresupuestoData(); 
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (presupuesto != null) {
      if (presupuesto.data != null){
        if (presupuesto.data['presupuesto'] != null){
          setState(() {
            presupuesto1 = presupuesto.data['presupuesto'].toStringAsFixed(2);  
          });
        }
      }
    }

    var gastos = await DatabaseService(uid: user.uid).getGastosData(); 
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (gastos != null) {
      if (gastos.data != null){
        if (gastos.data['gasto'] != null){
          var contador = 0;
          double porcentajeLimite;
          double gastoLimite;
          double gastoUtilizado;
          double porcentajeUsado;
          setState(() {
            _montosGastos.forEach((k,v) => {
              porcentajeLimite = _porcentajes[contador],
              gastoLimite = double.parse(presupuesto1.toString()) * (porcentajeLimite / 100.0),
              gastoUtilizado = double.parse(v),
              porcentajeUsado = gastoUtilizado * 100 /gastoLimite,
              if(porcentajeUsado > 100){
                porcentajeUsado = 100
              },
              if(porcentajeUsado > 90){
                _colores.add(GFColors.DANGER)
              }
              else if(porcentajeUsado > 70){
                _colores.add(GFColors.WARNING)
              }
              else if(porcentajeUsado > 40){
                _colores.add(GFColors.INFO)
              }
              else{
                _colores.add(GFColors.SUCCESS)
              },
              _gastoLimite.add(gastoLimite),
              _porcentajesUsados.add(porcentajeUsado),
              _gastadoActualmente.add(gastoUtilizado),              
              contador++
            });   
          });
        }
      }
    }
  }

  Future obtenerMontosGastos(user) async {
    var montos = await DatabaseService(uid: user.uid).getMontosGastosData(); 
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (montos != null) {
      if (montos.data != null){
        setState(() {
          _montosGastos = montos.data;
        });
      }
    }
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
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Mi Presupuesto',
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
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var i = 0; i < _gastos.length; i++) Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (_porcentajesUsados.asMap().containsKey(i))
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Presupuesto ya utilizado para ' + _gastos[i],
                              style: kLabelStyle,                
                            ),
                            SizedBox(height: 15.0),
                            GFProgressBar(
                              animation: true,
                              animationDuration: 1000,
                              lineHeight: 40,
                              percentage: _porcentajesUsados[i]/100,
                              child:  Center(
                                child: Text(_porcentajesUsados[i].toStringAsFixed(2) + '%', 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ),
                              backgroundColor : Colors.black26,
                              progressBarColor: _colores[i],
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Cantidad presupuestada Q' + _gastoLimite[i].toStringAsFixed(2),
                              style: kLabelStyle,                
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 230.0,
                                  width: 140.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Monto gastado para ' + _gastos[i],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      SleekCircularSlider(
                                        min: 0,
                                        max: 100,
                                        initialValue: _porcentajesUsados[i],
                                        appearance: CircularSliderAppearance(
                                          infoProperties: InfoProperties(
                                            bottomLabelText: 'Q' + _gastadoActualmente[i].toStringAsFixed(2),
                                            bottomLabelStyle: TextStyle(
                                              fontSize: 12
                                            ),
                                          ),
                                          customColors: CustomSliderColors(
                                            trackColor: _colores[i],
                                            progressBarColors: [
                                              _colores[i],
                                              _colores[i]
                                            ],
                                            gradientStartAngle: 0,
                                            gradientEndAngle: 180,
                                            dotColor:  Color(0xFFFFFFFF),
                                            hideShadow: false,
                                            shadowColor: Colors.black
                                          ),
                                        ),
                                      ),
                                    ],
                                  ), 
                                ),
                                if(_porcentajesUsados != null) Container(
                                  height: 230.0,
                                  width: 140.0,
                                  decoration: new BoxDecoration(
                                    color: Colors.green[50]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Monto restante para ' + _gastos[i],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      SleekCircularSlider(
                                        min: 0,
                                        max: 100,
                                        initialValue: 100 - _porcentajesUsados[i],
                                        appearance: CircularSliderAppearance(
                                          infoProperties: InfoProperties(
                                            bottomLabelText: 'Q' + (double.parse(presupuesto1.toString()) * (_porcentajes[i] / 100.0) - _gastadoActualmente[i]).toStringAsFixed(2),
                                            bottomLabelStyle: TextStyle(
                                              fontSize: 12
                                            ),
                                          ),
                                          customColors: CustomSliderColors(
                                            trackColor: _colores[i],
                                            progressBarColors: [
                                              _colores[i],
                                              _colores[i]
                                            ],
                                            gradientStartAngle: 0,
                                            gradientEndAngle: 180,
                                            dotColor:  Color(0xFFFFFFFF),
                                            hideShadow: false,
                                            shadowColor: Colors.black
                                          ),
                                        ),
                                      ),
                                    ],
                                  ), 
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}