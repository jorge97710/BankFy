import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection a la que haremos referencia
  final CollectionReference userDataCollection = Firestore.instance.collection('usuarios');

  Future updateUserData(String nombre, String apellido) async {
    print('Llegue Aqui ********************************************');
    return await userDataCollection.document(uid).setData({
      'nombre': nombre,
      'apeliido': apellido,
    });

  }
}