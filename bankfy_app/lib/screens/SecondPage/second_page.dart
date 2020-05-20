import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String payload;

  const SecondPage({
    @required this.payload,
    Key key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Verifica tu budget planner para ver la transacción',
            style: Theme.of(context).textTheme.title,
          ),
          const SizedBox(height: 8),
          Text(
            payload,
            style: Theme.of(context).textTheme.subtitle,
          ),
          const SizedBox(height: 8),
          RaisedButton(
            child: Text('Regresar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}