import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/screens/VistaPresupuestoScreen/vista_presupuesto_screen.dart';
import 'package:bankfyapp/screens/local_notifications_helper.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:bankfyapp/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:bankfyapp/screens/Agreement/agreement_dialog.dart' as fullDialog;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';

import '../../main.dart';

class CamaraScreen extends StatefulWidget {
  @override
  _CamaraScreen createState() => new _CamaraScreen();
}

class _CamaraScreen extends State<CamaraScreen> {
  final AuthService _auth = AuthService();
  final textoMontoTotalImagen = TextEditingController();
  File _image;
  double counter = 0.00;
  String dropdownValue = '';
  List<String> _gastos = [];
  bool revision = true;
  Map<String, dynamic> _montosGastos;

  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    super.initState();
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
  
  // Widget que define el componente del input del presupuesto inicial del periodo
  Widget _buildMontoTotalFacturaTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Monto total factura',
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
                return 'Ingrese el monto total correspondiente a su factura';
              }
              else if (!isNumeric(value)) {
                return 'Ingrese un monto numérico';
              }
              return null;
            },
            controller: textoMontoTotalImagen,
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
              hintText: 'Tome una foto de la factura',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
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
            dropdownValue = _gastos[0];   
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

  // Future _openAgreeDialog(context) async {
  //   String result = await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return fullDialog.CreateAgreement();
  //       },
  //       //true to display with a dismiss button rather than a return navigation arrow
  //       fullscreenDialog: true));
  //   if (result != null) {
  //     getImage();
  //   } else {
  //     print('you could do another action here if they cancel');
  //   }
  // }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

    double maximo = 0.00;

    FirebaseVisionImage receipt = FirebaseVisionImage.fromFile(_image);
    TextRecognizer getText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await getText.processImage(receipt);

    var lst = new List();

    for (TextBlock block in readText.blocks){
      for (TextLine line in block.lines){
        for (TextElement word in line.elements){
          if (word.text.contains(".")) {
            if (isNumeric(word.text)) {

              lst.add(double.parse(word.text));

              if (double.parse(word.text) > maximo) {
                maximo = double.parse(word.text);
                setState(() {
                  counter = maximo;
                  //_textImage = counter.toString();
                });
              }
            }
          }
        }
      }
    }

    for (var i = 0; i < lst.length; i++){
      if (lst[i] == maximo && (i+1)<lst.length){
        setState(() {
          counter = lst[i] - lst[i+1];
          textoMontoTotalImagen.text = counter.toStringAsFixed(2);
        });
      }
    }

    print(lst);

  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  // Widget que define el componente para el boton de Send Presupuesto
  Widget _buildSendBtn(user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (textoMontoTotalImagen.text != '' && isNumeric(textoMontoTotalImagen.text)) {
            List gastos = [];
            List montos = [];
            String gastito = '';
            double montitoAntes = 0.0;
            double montitoDespues = 0.0;
            _montosGastos.forEach((k,v) => {
              if (k.toString() == dropdownValue.toString()) {
                  gastos.add(k.toString()),
                  montos.add((double.parse(v) + double.tryParse(textoMontoTotalImagen.text)).toString()),
                  gastito = k.toString(),
                  montitoAntes = double.parse(v),
                  montitoDespues = double.parse(v) + double.tryParse(textoMontoTotalImagen.text)
              }
              else{
                  gastos.add(k.toString()),
                  montos.add(v.toString())
              }
            });

            // Se hace update del monto
            await DatabaseService(uid: user.uid).updateMontosGastosData(gastos, montos);
            // Condiciones para determinar los porcentajes de uso de algun monto
            var budget = await DatabaseService(uid: user.uid).getPresupuestoData();
            var gast = await DatabaseService(uid: user.uid).getGastosData(); 
            var monts = await DatabaseService(uid: user.uid).getMontosGastosData(); 

            if (budget != null && gast != null && monts != null) {
              if (budget.data != null && gast.data != null && monts.data != null){
                if (budget.data['presupuesto'] != null && gast.data['gasto'] != null){
                  // Obtenemos los montos
                  Map<String, dynamic> montadera;
                  var contador = 0;
                  double porcentajeLimite;
                  double gastoLimite;
                  // double gastoUtilizado;
                  double porcentajeUsadoAntes;
                  double porcentajeUsadoDespues;
                  String gastosHechos;

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
                    if (k.toString() == gastito) {
                      // Logica para mandar notificaciones
                      porcentajeLimite = porcentajedera[contador],
                      gastosHechos = gastadera[contador],
                      gastoLimite = double.parse(cantidadInicial.toString()) * (porcentajeLimite / 100.0),
                      porcentajeUsadoAntes = montitoAntes * 100 /gastoLimite,   
                      porcentajeUsadoDespues = montitoDespues * 100 /gastoLimite,
                      
                      // Notificaciones
                      if(porcentajeUsadoAntes < 100 && porcentajeUsadoDespues == 100){
                        showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 100%")
                      }
                      else if(porcentajeUsadoAntes < 90 && porcentajeUsadoDespues > 90){
                        if(porcentajeUsadoDespues == 100){
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 100%")
                        }
                        else {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 90%")
                        }
                      }
                      else if(porcentajeUsadoAntes < 70 && porcentajeUsadoDespues > 70){
                        if(porcentajeUsadoDespues > 100){
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 100%")
                        }
                        else if (porcentajeUsadoDespues > 90) {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 90%")
                        }
                        else {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 70%")
                        }
                      }
                      else if(porcentajeUsadoAntes < 50 && porcentajeUsadoDespues > 50){
                        if(porcentajeUsadoDespues > 100){
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 100%")
                        }
                        else if (porcentajeUsadoDespues > 90) {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 90%")
                        }
                        else if (porcentajeUsadoDespues > 70) {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 70%")
                        }
                        else {
                          showOngoingNotification(notifications, title: "Alerta", body: "Acabas de sobrepasar tu presupuesto de " + gastosHechos + " en un 50%")
                        }
                      }
                      else{
                        showOngoingNotification(notifications, title: "Tu gasto ha sido ingresado con éxito", body: "Revisa tu presupuesto para más información")
                      },
                    },
                    contador++,
                  });
                }  
              }
            }
            // showOngoingNotification(notifications, title: "Se hizo una transacción", body: "Revisa tu presupuesto para más información");
            textoMontoTotalImagen.clear();
            Navigator.pop(
              context
            );          
          }
          else {
            _showErrorSetMonto();
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Ingresar monto',
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

  _showErrorSetMonto() {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text("Error - Ingreso monto"),
        content: new Text("El monto ingresado no es válido"),
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

  @override
  Widget build(BuildContext context) {
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
      obtenerMontosGastos(user);
      revision = false;
    }

    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().gastos,
        child: Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text(
            'Ingreso de gasto - OCR',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Text("Total: " + _textImage),
                    _buildMontoTotalFacturaTF(),
                    // TextField(
                    //   obscureText: false,
                    //   textAlign: TextAlign.center,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: _textImage,
                    //   ),
                    // ),
                    SizedBox(height: 30.0),
                    Text(
                      'Tipo de Gasto',
                      style: kLabelStyle,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          
                          color: Colors.green[900]
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.green[800],
                        ),
                        onChanged: (String newValue){
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items:_gastos
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                            );
                        })
                        .toList(),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: getImage,
                            child: Text("Tomar Foto"),
                            color: Colors.green[500],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      child: _image == null
                        ? new Text("")
                        : new Image.file(_image)
                    ),
                    _buildSendBtn(user),
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
