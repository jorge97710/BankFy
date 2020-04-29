import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';



class CamaraScreen extends StatefulWidget {
  @override
  _CamaraScreen createState() => new _CamaraScreen();
}



class _CamaraScreen extends State<CamaraScreen> {
  
  File _image;
  String _textImage = "0.00";
  double counter = 0.00;

  
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });

    double maximo = 0.00;

    FirebaseVisionImage receipt = FirebaseVisionImage.fromFile(_image);
    TextRecognizer getText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await getText.processImage(receipt);

    var lst = new List();

    for (TextBlock block in readText.blocks){
      for (TextLine line in block.lines){
        for (TextElement word in line.elements){
          if (word.text.contains(".")) {
            if (isNumeric(word.text)) {

              lst.add(double.parse(word.text));

              if (double.parse(word.text) > maximo) {
                maximo = double.parse(word.text);
                setState(() {
                  counter = maximo;
                  //_textImage = counter.toString();
                });
              }
            }
          }
        }
      }
    }

    for (var i = 0; i < lst.length; i++){
      if (lst[i] == maximo && (i+1)<lst.length){
        setState(() {
          counter = lst[i] - lst[i+1];
          _textImage = counter.toString();
        });
      }
    }

    print(lst);

  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('OCR'),
          backgroundColor: Colors.green[500],
        ),
        body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                child: _image == null
                  ? new Text("No image selected")
                  : new Image.file(_image)
              ),
              Text("Total: " + _textImage),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  RaisedButton(
                    onPressed: getImage,
                    child: Text("Take Picture"),
                    color: Colors.green[500],
                  ),
                ],)
              )
            ],
          ),
        ),
        ),
      ),
    );
  }

}
