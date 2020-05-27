import 'package:bankfyapp/models/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankfyapp/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ConfiguracionPresupuestoScreen extends StatefulWidget {
  @override
  _ConfiguracionPresupuestoScreenState createState() => _ConfiguracionPresupuestoScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _ConfiguracionPresupuestoScreenState extends State<ConfiguracionPresupuestoScreen> {
  // Variables para poder manejar los textos y vistas de los inputs y ventana
  final presupuestoDelPeriodo = TextEditingController();
  final descripcionGasto = TextEditingController();
  final porcentajeGasto = TextEditingController();
  final fechaInicio = TextEditingController();
  final fechaFinal = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  List _periods = ["Semanal", "Quincenal", "Mensual"];
  List _gastos = [];
  List<double> _porcentajes = [];
  String fechaValidator = '';
  bool revision = true;

  @override
  void initState() {
    super.initState();
  }

  // here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String period in _periods) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: period,
          child: new Text(period)
      ));
    }
    return items;
  }

  void deleteTile(int index) {
    setState(() {
      _gastos.removeAt(index);
      _porcentajes.removeAt(index);
    });
  }

  bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
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
          presupuestoDelPeriodo.text = presupuesto.data['presupuesto'].toStringAsFixed(2);
        }
        if (presupuesto.data['fecha_inicio'] != null){
          fechaInicio.text = presupuesto.data['fecha_inicio'].toString();
          fechaFinal.text = presupuesto.data['fecha_final'].toString();
        }
      }
    }
  }

  // Widget que define el componente del input del presupuesto inicial del periodo
  Widget _buildPresupuestoInicialPeriodoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Presupuesto actual',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationWhiteStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese el monto correspondiente al presupuesto';
              }
              else if (!isNumeric(value)) {
                return 'Ingrese un monto numérico';
              }
              return null;
            },
            controller: presupuestoDelPeriodo,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              hintText: 'Ingrese un monto',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget que define un text field para la descripcion del gasto
  Widget _buildDescripcionGastoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombre del gasto',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationWhiteStyle,
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese un gasto';
              }
              return null;
            },
            controller: descripcionGasto,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              hintText: 'Gasto',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget que define un text field para el porcentaje asignado al gasto
  Widget _buildPorcentajeGastoTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Porcentaje del gasto',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationWhiteStyle,
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextFormField(
            validator: (value) {
              var contador = 0.0;
              for (double cantidad in _porcentajes){
                contador = contador + cantidad; 
              }
              if (value.isEmpty) {
                return 'Porcentaje inválido';
              }
              else if (!isNumeric(value)) {
                return 'Porcentaje inválido';
              }
              else if ((contador + int.parse(value)) > 100) {
                return 'Porcentaje inválido';
              }
              return null;
            },
            controller: porcentajeGasto,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.attach_money,
                color: Colors.black,
              ),
              hintText: 'Porcentaje',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget que define el componente para Login con Google
  Widget _buildTFContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildDescripcionGastoTF(),
          _buildPorcentajeGastoTF(),
        ],
      ),
    );
  }

  // Widget que define el componente para el boton de Send Presupuesto
  Widget _buildSendBtn(user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          var fechaHoy = new DateTime.now();
          var formatHoy = DateFormat("dd-MM-yyyy", "es_GT");
          String fechaStringHoy = formatHoy.format(fechaHoy);
          if (_formKey.currentState.validate() && _gastos.length != 0 && DateFormat("dd-MM-yyyy", "es_GT").parse(fechaFinal.text).isAfter(DateFormat("dd-MM-yyyy", "es_GT").parse(fechaInicio.text)) && DateFormat("dd-MM-yyyy", "es_GT").parse(fechaFinal.text).isAfter(DateFormat("dd-MM-yyyy", "es_GT").parse(fechaStringHoy))) {
            await DatabaseService(uid: user.uid).updatePresupuestoData(presupuestoDelPeriodo.text.toString(), fechaInicio.text, fechaFinal.text);
            await DatabaseService(uid: user.uid).updateGastosData(_gastos, _porcentajes);
            List montos = [];
            for(var i = 0; i < _gastos.length; i++){
              montos.add(0);
            }
            await DatabaseService(uid: user.uid).updateMontosGastosData(_gastos, montos);
            presupuestoDelPeriodo.clear();
            descripcionGasto.clear();
            porcentajeGasto.clear();
            Navigator.pop(
              context
            );
          }
          else {
            _showErrorIngresarPresupuesto();
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Ingresar presupuesto',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  // Widget que define el componente para el boton de Send Presupuesto
  Widget _buildCloseBudgetBtn(user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
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
                Map<String, dynamic> montadera;

                var contador = 0;
                double porcentajeLimite;
                double gastoLimite;
                double gastoUtilizado;
                String gastosHechos;
                double cantidadRestante = 0.0; // = 100;
                var fechaFinal = fechaString;
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

                // await DatabaseService(uid: user.uid).updatePresupuestoData(presupuestoDelPeriodo.text.toString(), fechaInicio.text, fechaFinal.text);
                // await DatabaseService(uid: user.uid).updateGastosData(_gastos, _porcentajes);
                // List montos = [];
                // for(var i = 0; i < _gastos.length; i++){
                  // montos.add(0);
                // }
                // await DatabaseService(uid: user.uid).updateMontosGastosData(_gastos, montos);
                presupuestoDelPeriodo.clear();
                descripcionGasto.clear();
                porcentajeGasto.clear();
                Navigator.pop(
                  context
                );
              }
              else {
                _showErrorSetPresupuesto();
              }  
            }
            else {
              _showErrorSetPresupuesto();
            }
          }
          else {
            _showErrorSetPresupuesto();
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Cerrar presupuesto actual',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  _showErrorSetPresupuesto() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Error - Presupuesto no activo"),
        content: new Text("Primero debes tener un presupuesto activo antes de poder cerrar uno"),
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

  _showErrorIngresarPresupuesto() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Error en los datos"),
        content: new Text("Asegurese de haber ingresado fechas correctas para el presupuesto, y al menos un gasto"),
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

  // Widget que define el componente para el boton de Set Presupuesto
  Widget _buildSetGastoBtn(user) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.of(context).size.width * 0.75,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey2.currentState.validate()) {
            setState(() {
              _gastos.add(descripcionGasto.text);
              _porcentajes.add(int.parse(porcentajeGasto.text).toDouble());
            });
            descripcionGasto.clear();
            porcentajeGasto.clear();
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Agregar gasto',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
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
              //Navigator.pop(context);
            },
          ), 
        );
      });
    }

    if (revision) {
      obtenerGastos(user);
      obtenerPresupuesto(user);
      revision = false;
    }

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().gastos,
        child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text(
            'Configuración de presupuesto',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
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
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _buildPresupuestoInicialPeriodoTF(),
                              SizedBox(height: 40.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Periodo del presupuesto',
                                    style: kLabelStyle,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            constraints: BoxConstraints(minWidth: 100, maxWidth: 150),
                                            alignment: Alignment.center,
                                            child: Column(children: <Widget>[
                                              Text(
                                                'Fecha inicio',
                                                style: kLabelStyle,
                                              ),
                                              DateTimeField(
                                                format: DateFormat("dd-MM-yyyy"),
                                                controller: fechaInicio,
                                                onShowPicker: (context, currentValue) {
                                                  return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    locale : const Locale('es','GT'),
                                                    initialDate: currentValue ?? DateTime.now(),
                                                    lastDate: DateTime(2100));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            constraints: BoxConstraints(minWidth: 100, maxWidth: 150),
                                            alignment: Alignment.center,
                                            child: Column(children: <Widget>[
                                              Text(
                                                'Fecha final',
                                                style: kLabelStyle,
                                              ),
                                              DateTimeField(
                                                format: DateFormat("dd-MM-yyyy"),
                                                controller: fechaFinal,
                                                onShowPicker: (context, currentValue) {
                                                  return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    locale : const Locale('es','GT'),
                                                    initialDate: currentValue ?? DateTime.now(),
                                                    lastDate: DateTime(2100));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                          key: _formKey2,
                          child: Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Gastos del presupuesto',
                                    style: kLabelStyle,
                                  ),
                                  _buildTFContainer(),
                                  for (var i = 0; i < _gastos.length; i++) ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text(_gastos[i]),
                                    subtitle: Text('Porcentaje de gasto: ' + _porcentajes[i].toString() + '%'),
                                    onTap: () => deleteTile(i),
                                  ),
                                  StreamProvider<QuerySnapshot>.value(
                                    value: DatabaseService().gastos,
                                      child: _buildSetGastoBtn(user),
                                  ),
                                  _buildSendBtn(user),
                                  _buildCloseBudgetBtn(user),
                                ],
                              ),
                            ],
                          ),
                        ),
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