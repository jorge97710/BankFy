
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server
import 'package:flutter/material.dart';


//usuario y password
String username = "";
String password = "";

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState() => new _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {

  // crear servidor
  final smtpServer = gmail(username, password);
    
  
  Future sendMessage() async {
    final message = Message()
    ..from = Address(username)
    ..recipients.add('') //correo que va a recibir el mensaje
    ..ccRecipients.addAll([username]) //cc los otros que lo van a recibir
    ..subject = 'Test Flutter-Dart Mailer  :: 😀 :: ${DateTime.now()}' // Tema
    ..text = 'Probando..1..2..3. De una recomiendo unos anime :P\n ---Haikyuu\n ---Psycho Pass\n ---Code Geass\n ---Fullmetal Alchemist Brotherhood\n ---Gundam Iron Blooded Orphans' //body of the email
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
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: RaisedButton(
                onPressed: sendMessage,
                child: Text("Tomar Foto"),
                color: Colors.blue[500]
              ),
            ),
        ),
      ),
    );
  }

}
