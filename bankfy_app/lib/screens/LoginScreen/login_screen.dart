import 'package:bankfyapp/screens/MainScreen/main_screen.dart';
import 'package:bankfyapp/services/auth.dart';
import 'package:bankfyapp/utilities/constants.dart';
import 'package:bankfyapp/utilities/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables para poder manejar los textos y vistas de los inputs y ventana
  final email = TextEditingController();
  final pass = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // bool _rememberMe = false;
  bool loading = false;
  bool _showSignIn = true;
  String error = '';

  // Funcion para cambiar la pantalla de Registro y la de Login
  void toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
      error = '';
    });  
  }

  // Funcion para validar los formatos de emails
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Por favor ingrese un correo válido';
    else
      return null;
  }

  // Se hacer un dispose de los manejadores de inputs
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    pass.dispose();
    nombre.dispose();
    apellido.dispose();
    super.dispose();
  }

  // Widget que define el componente del input del email
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Correo',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) => validateEmail(value),
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Ingrese su correo',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  // Widget que define el componente del input del password
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contraseña',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.length < 6 || value.isEmpty) {
                return 'Ingrese una contraseña con al menos 6 caracteres';
              }
              return null;
            },
            controller: pass,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Ingrese su contraseña',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget que define el componente del input del nombre del usuario
  Widget _buildFirstNameUserTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombre del usuario',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese su primer nombre';
              }
              return null;
            },
            controller: nombre,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: 'Ingrese su primer nombre',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // Widget que define el componente del input del nombre del usuario
  Widget _buildLastNameUserTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Apellido del usuario',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Ingrese su primer apellido';
              }
              return null;
            },
            controller: apellido,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              errorStyle: TextStyle(
                fontSize: 10.0,
              ),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: 'Ingrese su primer apellido',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // // Widget que define el componente para poder recuperar password
  // Widget _buildForgotPasswordBtn() {
  //   return Container(
  //     alignment: Alignment.centerRight,
  //     child: FlatButton(
  //       onPressed: () => print('Forgot Password Button Pressed'),
  //       padding: EdgeInsets.only(right: 0.0),
  //       child: Text(
  //         '¿Olvidaste tu contraseña?',
  //         style: kLabelStyle,
  //       ),
  //     ),
  //   );
  // }

  // // Widget que define el componente de recordar usuario y contraseña
  // Widget _buildRememberMeCheckbox() {
  //   return Container(
  //     height: 20.0,
  //     child: Row(
  //       children: <Widget>[
  //         Theme(
  //           data: ThemeData(unselectedWidgetColor: Colors.black),
  //           child: Checkbox(
  //             value: _rememberMe,
  //             checkColor: Colors.green,
  //             activeColor: Colors.black,
  //             onChanged: (value) {
  //               setState(() {
  //                 _rememberMe = value;
  //               });
  //             },
  //           ),
  //         ),
  //         Text(
  //           'Recordar usuario y contraseña',
  //           style: kLabelStyle,  
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget que define el componente para el boton de Login
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              loading = true;
            });
            dynamic result = await _auth.signInWithEmailAndPassword(email.text, pass.text);
            if (result == null) {
              setState(() {
                error = 'Correo y/o contraseña inválido';
                loading = false;
              });
              email.clear();
              pass.clear();
              nombre.clear();
              apellido.clear();
            } else {
              //This makes sure the textfield is cleared after page is pushed.
              email.clear();
              pass.clear();
              nombre.clear();
              apellido.clear();
            }
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black,
        child: Text(
          'Ingresar',
          style: TextStyle(
            color: Color(0xFF95F985),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  // Widget que define el componente para el boton de Registro
  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              loading = true;
            });
            dynamic result = await _auth.registerWithEmailAndPassword(email.text, pass.text, nombre.text, apellido.text);
            if (result == null) {
              setState(() {
                error = 'El correo ya está vinculado a una cuenta';
                loading = false;
              });
            } else {
              email.clear();
              pass.clear();
              nombre.clear();
              apellido.clear();
              this.toggleView();
            }
          }
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black,
        child: Text(
          'Registrar',
          style: TextStyle(
            color: Color(0xFF95F985),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  // Widget que define el componente para el boton de Back to SignIN
  Widget _buildBackSignInBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          email.clear();
          pass.clear();
          nombre.clear();
          apellido.clear();
          this.toggleView();
        },
        padding: EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black,
        child: Text(
          'Volver al ingreso',
          style: TextStyle(
            color: Color(0xFF95F985),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  // Widget que define el componente de Texto Auxiliar
  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          ' O ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Ingresa con',
          style: kLabelStyle,
        ),
      ],
    );
  }

  // Widget que define el componente para hacer Login con Google
  Widget _buildGoogleEmail(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          )
        ),
      ),
    );
  }

  // Widget que define el componente para Login con Google
  Widget _buildButonsSignIn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildGoogleEmail(
            () => print('Ingresando con Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  // Widget que define el componente para la opcion de registro
  Widget _buildSingUpBtn() {
    return GestureDetector(
      onTap: () {
        _formKey.currentState.reset();   
        this.toggleView();
      },
      child: RichText(
        text: TextSpan(
          children:[
            TextSpan(
              text: '¿Aún no tienes cuenta? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Registrate ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Aqui se hace el build de la ventana
  @override
  Widget build(BuildContext context) {
    if (_showSignIn) {
      // Aqui se hace la ventana de Login
      return loading ? Loading() : Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00AB08),
                    Color(0xFF00C301),
                    Color(0xFF26D701),
                    Color(0xFF4DED30),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9]
                )
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Bankfy',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildEmailTF(),
                          SizedBox(height: 30.0),
                          _buildPasswordTF(),
                          SizedBox(height: 30.0),
                          //_buildForgotPasswordBtn(),
                          //_buildRememberMeCheckbox(),
                          SizedBox(height: 5.0),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              ),
                          ),
                          _buildLoginBtn(),
                          //_buildSignInWithText(),
                          //_buildButonsSignIn(),
                          _buildSingUpBtn(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      // Aqui se hace la ventana de Registro
      return loading ? Loading() : Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00AB08),
                    Color(0xFF00C301),
                    Color(0xFF26D701),
                    Color(0xFF4DED30),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9]
                )
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Registro',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildFirstNameUserTF(),
                          SizedBox(height: 30.0),
                          _buildLastNameUserTF(),
                          SizedBox(height: 30.0),
                          _buildEmailTF(),
                          SizedBox(height: 30.0),
                          _buildPasswordTF(),
                          SizedBox(height: 5.0),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              ),
                          ),
                          SizedBox(height: 10.0),
                          _buildRegisterBtn(),
                          _buildBackSignInBtn(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );      
    }
  }
}