
//import 'package:bankfyapp/utilities/constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server
import 'package:flutter/material.dart';


//usuario y password
String username = "bankfyc@gmail.com";
String password = "";

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState() => new _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {

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
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacto',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacto'),
          backgroundColor: Colors.green[500],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Text(""),

            TextField(
              keyboardType: TextInputType.text,
              controller: subjectController,
              decoration: InputDecoration(
                hintText: 'Sujeto'
              )
            ),

            TextField(
              keyboardType: TextInputType.text,
              controller: contentController,
              decoration: InputDecoration(
                hintText: 'Mensaje'
              )
            ),

            Text(""),
            Text(""),

            RaisedButton(
              onPressed: sendMessage,
              child: Text("Enviar"),
              color: Colors.green[500]
            ),

          ],
        ),
      ),
    );
  }

}
