import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class TextoNombreUsuario extends StatefulWidget {
  @override 
  _TextoNombreUsuarioState createState() => _TextoNombreUsuarioState();
}

class _TextoNombreUsuarioState extends State<TextoNombreUsuario> {
  @override 
  Widget build(BuildContext context) {

    final datos = Provider.of<QuerySnapshot>(context);
    String nombre = '';

    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (datos != null) {
      nombre = datos.documents[0]['nombre'];
    } else {
      nombre = '';    
    }

    // Se devuelve el texto
    return Text(
      'Bienvenido ' + nombre,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
