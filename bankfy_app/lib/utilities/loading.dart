import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF00AB08),
      child: Center(
        child: SpinKitWanderingCubes(
          color: Colors.green[50],
          size: 50.0,
        ),
      ),
    );
  }
}