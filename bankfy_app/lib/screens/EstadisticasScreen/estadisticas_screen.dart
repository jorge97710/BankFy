/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  List<TimeSeriesSales> data;
  List<TimeSeriesSales> data2;
  bool revision = true;
  String dropdownValue = '';
  List<String> _gastos = [];
  List<String> _gastosNoLista = [];
  List<TimeSeriesSales> dataGeneral;

  @override
  void initState() {
    data = [];
    data2 = [];
    dataGeneral = [];
    super.initState();
    Future.delayed(Duration.zero,() {
      obtenerHistorial(Provider.of<User>(context, listen: false));
    });
  }

  Future obtenerHistorial(user) async {
    var historialResiduos = await DatabaseService(uid: user.uid).getHistorialResiduosData(); 
    var historialGastos = await DatabaseService(uid: user.uid).getHistorialGastosData(); 
    var historialMontos = await DatabaseService(uid: user.uid).getHistorialMontosData(); 
    List<TimeSeriesSales> a = [];
    List<TimeSeriesSales> b = [];
    List<TimeSeriesSales> c = [];
    // Se revisa si aun no se ha obtenido respuesta de Firebase
    if (historialResiduos != null && historialGastos != null && historialMontos != null) {
      if (historialResiduos.data != null && historialGastos != null && historialMontos != null){
        historialResiduos.data.forEach((k,v) => {
          a.add(new TimeSeriesSales(DateFormat("dd-MM-yyyy", "es_GT").parse(k), v) )
        });
        historialGastos.data.forEach((k,v) => {
          setState(() {
            for(var e in v){
              if(!_gastos.contains(e[0].toString().toUpperCase()+e.toString().substring(1).toLowerCase())){
                _gastos.add(e[0].toString().toUpperCase()+e.toString().substring(1).toLowerCase());
              }
              _gastosNoLista.add(e);
            }   
            dropdownValue = _gastos[0];   
          })
        });
        historialMontos.data.forEach((k,v) => {
          setState(() {
            for (var i in v){
              c.add(new TimeSeriesSales(DateFormat("dd-MM-yyyy", "es_GT").parse(k), i));
              dataGeneral.add(new TimeSeriesSales(DateFormat("dd-MM-yyyy", "es_GT").parse(k), i));
            }
          })
        });

        // Ordenamiento general
        Comparator<TimeSeriesSales> fechasComparator = (a, b) => a.time.compareTo(b.time);
        a.sort(fechasComparator);

        // Ordenamiento especifico
        var indices = [];
        var contador = 0;
        for(var x in _gastosNoLista){
          if(x.toLowerCase() == _gastos[0].toLowerCase()){
            indices.add(contador);
          }
          contador++;
        }

        for(var y in indices){
          b.add(c[y]);
        }

        b.sort(fechasComparator);

        // Set Datos
        setState(() {
          data = a;
          data2 = b;
        });
      }
    }
  }

  changeGraph(){
    Comparator<TimeSeriesSales> fechasComparator = (a, b) => a.time.compareTo(b.time);
    List<TimeSeriesSales> b = [];
    // Ordenamiento especifico
    var indices = [];
    var contador = 0;
    for(var x in _gastosNoLista){
      if(x.toLowerCase() == dropdownValue.toLowerCase()){
        indices.add(contador);
      }
      contador++;
    }

    for(var y in indices){
      b.add(dataGeneral[y]);
    }

    b.sort(fechasComparator);

    // Set Datos
    setState(() {
      data2 = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    var series = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];

    var series2 = [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data2,
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

    var chart2 =  new charts.TimeSeriesChart(
      series2,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        new charts.ChartTitle('Desempeño en ' + dropdownValue,
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

    var chartWidget2 = new SizedBox(
      height: 300.0,
      child: chart2,
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
                    SizedBox(height: 30),
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
                            changeGraph();
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
                    chartWidget2,
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
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}