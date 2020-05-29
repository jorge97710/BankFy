// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(bankgt());

class bankgt extends StatelessWidget {
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
                    'Banco G&T Continental',
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
          TextSpan(text: 'Serie A', style: TextStyle(fontWeight: FontWeight.w900)),
          TextSpan(text: "\n\n"),
          TextSpan(text: " Beneficios:", style: TextStyle(fontWeight: FontWeight.w600)),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Cuenta de ahorro con sorteo"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Sorteos mensuales"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Banca electronica"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Tarjeta de debito"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "\n\n"),

          TextSpan(text: 'Requisitos:', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-DPI"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Recibo de servicios"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Referencias personales"),
          TextSpan(text: "\n\n"),
          TextSpan(text: "-Formulario solicitud"),
        ],
      ),
      )
    );

    return MaterialApp(
      title: 'Banco G&T Continental',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Banco G&T Continental'),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          children: [
            Image.asset(
              'assets/logos/g&t.png',
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