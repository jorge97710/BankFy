/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EstadisticasScreen extends StatefulWidget {
  @override
  _EstadisticasScreenState createState() => _EstadisticasScreenState();
}

class ScreenArguments {
  final String usuario;
  final String contrasena;

  ScreenArguments(this.usuario, this.contrasena);
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final AuthService _auth = AuthService();
  var data = [];
  bool revision = true;

  @override
  void initState() {
    super.initState();
  }

  Future obtenerHistorial(user) async {
    var historial = await DatabaseService(uid: user.uid).getGastosData(); 
    // Se revisa si aun no se ha obtenido respuesta de Firebase

  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (revision) {
      obtenerHistorial(user);
      revision = false;
    }

    var data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), -5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    var series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];

    var chart =  new charts.TimeSeriesChart(
      series,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        new charts.ChartTitle('Desempeño general',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            innerPadding: 35),
        new charts.ChartTitle('Fecha final del periodo',
            behaviorPosition: charts.BehaviorPosition.bottom,
            innerPadding: 20,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Superavit / Deficit',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );

    var chartWidget = new SizedBox(
      height: 300.0,
      child: chart,
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
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text(
            'Estadisticas de desempeño',
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
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    chartWidget,
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

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}