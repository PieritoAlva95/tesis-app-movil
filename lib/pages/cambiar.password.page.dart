import 'package:flutter/material.dart';
import 'package:jobsapp/models/password.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPage createState() => _CambiarPasswordPage();
}

class _CambiarPasswordPage extends State<CambiarPasswordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool visiblePasswordActual = true;
  bool visible = true;
  bool visibleConfirmarPassword = true;


  TextEditingController _passActualController = TextEditingController();
  TextEditingController _passNuevaController = TextEditingController();
  TextEditingController _confirmarPassNuevaController = TextEditingController();


 final usuarioProvider = UsuariosProvider();
   final preferenciaToken = PreferenciasUsuario();
    bool estaLogueado = false;


  Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
      estaLogueado = false;
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardPage()), (Route<dynamic> route) => false);
    }else{
      estaLogueado = true;
      print('Token válido ${preferenciaToken.token}');
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
        verificarToken();
        
  }


  @override
  Widget build(BuildContext context) {
  _passActualController.text = preferenciaToken.passwordActual.toString();
  print(_passActualController.text.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambia tu contraseña'),
      ),
      key: scaffoldKey,
      //drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  _loginForm(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 80.0,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                SizedBox(height: 30.0,),
                _crearPasswordActual(),
                SizedBox(height: 30.0,),
                _crearPassword(),
                SizedBox(height: 30.0,),
                _crearConfirmarPassword(),
                SizedBox(height: 60.0,),
                _crearBoton(),
                SizedBox(height: 60.0,),
              ],
            ),
          ),
        ],
      ),
    );
  }

   _crearPasswordActual() {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _passActualController,
            obscureText:visiblePasswordActual,
            decoration: InputDecoration(
               
                suffixIcon: IconButton(
                  icon: Icon(visiblePasswordActual ? Icons.visibility_off : Icons.visibility),
                  onPressed: (){
                    if(mounted)
                     setState(() {
                    visiblePasswordActual = !visiblePasswordActual;
                  });
                  },
                ),
                labelText: 'Contraseña Actual',
                //counterText: snapshot.data,
                ),
            
          ),
        );
  }


  _crearPassword() {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _passNuevaController,
            obscureText:visible,
            decoration: InputDecoration(
                
                suffixIcon: IconButton(
                  icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                  onPressed: (){
                    if(mounted)
                     setState(() {
                    visible = !visible;
                  });
                  },
                ),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                ),
            
          ),
        );
  }

    _crearConfirmarPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
                controller: _confirmarPassNuevaController,
                obscureText:visibleConfirmarPassword,
              decoration: InputDecoration(
                  
                  suffixIcon: IconButton(
                    icon: Icon(visibleConfirmarPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: (){
                      if(mounted)
                       setState(() {
                      visibleConfirmarPassword = !visibleConfirmarPassword;
                    });
                    },
                  ),
                  labelText: 'Contraseña',
                  //counterText: snapshot.data,
                  ),
              ),
    );
  }


  _crearBoton() {
    return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Text('Cambiar contraseña'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 10.0,
          color: Color.fromRGBO(53, 80, 112, 1.0),
          textColor: Colors.white,
          onPressed: () {
                  _cambiarPassword(context);
                },
        );
  }

  _cambiarPassword(BuildContext context) async {

      if(_passNuevaController.text.toString() == _confirmarPassNuevaController.text.toString()){
        Password pass = Password();

    pass.passwordActual = _passActualController.text.toString();
    pass.password = _passNuevaController.text.toString();
    
    final respuesta = await usuarioProvider.editarPasswordDelUsuario(pass);
              print('Respuesta: ${respuesta}');
              _passActualController.text = '';
              _passNuevaController.text = '';
              preferenciaToken.clear();
              print('ELIMINANDO TOKEN ${preferenciaToken.token}');
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login', (route) => false);
    
      }else{
          mostrarSnackBar('Las contraseñas no son iguales');
      }
    
  }
 void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1800),
      backgroundColor: Color.fromRGBO(29, 53, 87, 1.0),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }
 
}