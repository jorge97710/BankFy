// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(bank());

class bank extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Banco Industrial',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Text(
                  'Guatemala',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
        ],
      ),
    );
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'LLAMAR'),
          _buildButtonColumn(color, Icons.near_me, 'IR'),
          _buildButtonColumn(color, Icons.share, 'COMPARTIR'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text.rich(
        TextSpan(
        children: <TextSpan> [
          TextSpan(text: 'Ahorro seguro', style: TextStyle(fontWeight: FontWeight.w900)),
          TextSpan(text: "\n\n"),
          TextSpan(text: "Beneficios:", style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Cantidad de retiros ilimitados"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Capitalización de intereses cada 6 meses"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Servicios electrónicos como Bi Móvil"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Bi en Línea"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Bi Voz"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Realizar depósitos sin presentar libreta de ahorros"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Acceso por Bi en Línea a más de 2000 proveedores en donde podrás realizar tus pagos de servicio como agua,    luz, teléfono, colegios, etc"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Sorteos trimestrales de premios en efectivo.Descuentos en Seguros Opcionales.Beneficios por rango."),
          TextSpan(text: "\n\n"),
          TextSpan(text: "\n\n"),

          TextSpan(text: 'Requisitos:', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-DPI (original y copia)"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Recibo de servicios (original y copia)"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-NIT (opcional)"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Solicitud de apertura"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Monto de apertura de Q2500"),
        ],
      ),
      )
    );

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Banco Industrial',
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
        body: ListView(
          children: [
            Image.asset(
              'assets/logos/BI.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
            ],
        ),
      ),
    );
  }
  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}