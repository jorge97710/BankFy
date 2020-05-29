import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:provider/provider.dart';

import 'bank.dart';
import 'bankgt.dart';
import 'banrural.dart';
import 'bac.dart';
import 'promerica.dart';
import 'bantrab.dart';

class ListaB extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
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
            'Lista de Bancos',
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
            ListaBancos(),
          ],
        ),
      ),
    );
  }
}

class ListaBancos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}
Widget _myListView(BuildContext context) {

  final titles = ['BANCO INDUSTRIAL', 'BANCO G&T CONTINENTAL', 'BANRURAL',
    'BAC', 'PROMERICA', 'BANTRAB'];

  final icons = [Icons.directions_bike, Icons.directions_boat,
    Icons.directions_bus, Icons.directions_car, Icons.directions_railway,
    Icons.directions_run, Icons.directions_subway, Icons.directions_transit];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card( //
        //                         <-- Card widget
        color: Colors.green[100],
        child: ListTile(
          leading: Icon(Icons.business),
          title: Text(titles[index]),
          onTap: () {
            
            if (titles[index] == "BANCO INDUSTRIAL") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => bank()),
              );
            }

            if (titles[index] == "BANCO G&T CONTINENTAL") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => bankgt()),
              );
            }

            if (titles[index] == "BANRURAL") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => banrural()),
              );
            }

            if (titles[index] == "BAC") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => bac()),
              );
            }

            if (titles[index] == "PROMERICA") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => promerica()),
              );
            }

            if (titles[index] == "BANTRAB") {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => bantrab()),
              );
            }
            
          },
        ),
      );
    },
  );
}