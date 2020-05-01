import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // Collection a la que haremos referencia
  final CollectionReference userDataCollection = Firestore.instance.collection('usuarios');

  final CollectionReference gastosDataCollection = Firestore.instance.collection('gastos');

  final CollectionReference presupuestoDataCollection = Firestore.instance.collection('presupuestos');

  final CollectionReference montosGastosDataCollection = Firestore.instance.collection('montos');

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

  Future updatePresupuestoData(String presupuesto, String fechaInicio, String fechaFinal) async {
    return await presupuestoDataCollection.document(uid).setData({
      'presupuesto': double.parse(presupuesto),
      'fecha_inicio': fechaInicio,
      'fecha_final': fechaFinal,
    });
  }

  Future updateMontosGastosData(List gastos, List montos) async {
    List<String> gasto = gastos.map((e) => e.toString()).toList();
    List<String> monto = montos.map((e) => e.toString()).toList();

    Map<String, String> map = Map.fromIterables(gasto, monto);
    return await montosGastosDataCollection.document(uid).setData(map);
  }

  Future getGastosData() async {
    return await gastosDataCollection.document(uid).get();
  }

  Future getPresupuestoData() async {
    return await presupuestoDataCollection.document(uid).get();
  }

  Future getMontosGastosData() async {
    return await montosGastosDataCollection.document(uid).get();
  }

  // Obtener los datos del Usuario Stream
  Stream<QuerySnapshot> get datos {
    return userDataCollection.snapshots();
  }

  // Obtener los datos de los gastos del usuario
  Stream<QuerySnapshot> get gastos {
    return gastosDataCollection.snapshots();
  }

  // Obtener el presupuesto del usuario
  Stream<QuerySnapshot> get presupuestos {
    return presupuestoDataCollection.snapshots();
  }  
}