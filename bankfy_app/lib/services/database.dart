import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection a la que haremos referencia
  final CollectionReference userDataCollection = Firestore.instance.collection('usuarios');

  final CollectionReference gastosDataCollection = Firestore.instance.collection('gastos');

  Future updateUserData(String nombre, String apellido) async {
    return await userDataCollection.document(uid).setData({
      'nombre': nombre,
      'apellido': apellido,
    });
  }

  Future updateGastosData(List gastos, List porcentajes) async {
    return await gastosDataCollection.document(uid).setData({
      'gasto': gastos,
      'porcentaje': porcentajes,
    });
  }

  //  Obtener los datos del Usuario Stream
  Stream<QuerySnapshot> get datos {
    return userDataCollection.snapshots();
  }
}