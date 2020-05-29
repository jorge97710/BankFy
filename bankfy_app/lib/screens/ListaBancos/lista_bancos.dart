import 'package:flutter/material.dart';

import 'bank.dart';
import 'bankgt.dart';
import 'banrural.dart';
import 'bac.dart';
import 'promerica.dart';
import 'bantrab.dart';

class ListaB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Lista de Bancos')),
        body: ListaBancos(),
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
        child: ListTile(
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