import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/screens/BudgetPlannerScreen/budget_planner_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankfyapp/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  List _periods = ["Semanal", "Quincenal", "Mensual"];
  List _gastos = [];
  List<double> _porcentajes = [];
  String _currentPeriod;
  bool revision = true;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentPeriod = _dropDownMenuItems[0].value;
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

  void changedDropDownItem(String selectedPeriod) {
    setState(() {
      _currentPeriod = selectedPeriod;
    });
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
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState.validate() && _gastos.length != 0) {
            await DatabaseService(uid: user.uid).updatePresupuestoData(presupuestoDelPeriodo.text.toString(), _currentPeriod);
            await DatabaseService(uid: user.uid).updateGastosData(_gastos, _porcentajes);
            presupuestoDelPeriodo.clear();
            descripcionGasto.clear();
            porcentajeGasto.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BudgetPlannerScreen()
              )
            );
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
                          Form(key: _formKey,child: Column(children: <Widget>[
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
                                  SizedBox(height: 10.0),
                                  Container(
                                    alignment: Alignment.center,
                                    child: new DropdownButton(
                                      value: _currentPeriod,
                                      items: _dropDownMenuItems,
                                      onChanged: changedDropDownItem,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ],),),

                          SizedBox(height: 30.0),
                          Form(key: _formKey2,child: Column(children: <Widget>[
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
                            ],
                          ),
                          ],),),
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