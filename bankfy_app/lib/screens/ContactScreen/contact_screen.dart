
//import 'package:bankfyapp/utilities/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/models/user.dart';
import 'package:bankfyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//usuario y password
String username = "bankfyc@gmail.com";
String password = "";

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState() => new _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {
  final AuthService _auth = AuthService();
  var _sujeto;
  var _contenindo;

  final subjectController = new TextEditingController();
  final contentController = new TextEditingController();

  // crear servidor
  final smtpServer = gmail(username, password);
  
  Future sendMessage() async {

    setState(() {
      _sujeto = subjectController.text;
      _contenindo = contentController.text;
    });

    print(_sujeto);
    print(_contenindo);

    final message = Message()
    ..from = Address(username)
    ..recipients.add(username) //correo que va a recibir el mensaje
    //..ccRecipients.addAll([username]) //cc los otros que lo van a recibir
    ..subject = '$_sujeto: ${DateTime.now()}' // Tema
    ..text = _contenindo //body of the email
    ;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString()); //print if the email is sent
      subjectController.clear();
      contentController.clear();
      Navigator.pop(
        context
      );
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<User>(context);

    setState(() {
      subjectController.text = user.correo;
    });

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
            'Contáctanos',
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
                    SizedBox(height: 10.0),

                    // TextField(
                    //   keyboardType: TextInputType.text,
                    //   controller: subjectController,
                    //   decoration: InputDecoration(
                    //     hintText: user.correo
                    //   )
                    // ),

                    TextField(
                      keyboardType: TextInputType.text,
                      controller: contentController,
                      decoration: InputDecoration(
                      hintText: '¿Tienes alguna recomendación?'
                      )
                    ),

                    SizedBox(height: 30.0),

                    RaisedButton(
                      onPressed: sendMessage,
                      child: Text("Enviar"),
                      color: Colors.green[500]
                    ),   
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
