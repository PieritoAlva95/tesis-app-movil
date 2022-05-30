import 'package:flutter/material.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class MenuOpcionesPrincipalesWidget extends StatelessWidget {
  const MenuOpcionesPrincipalesWidget({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferencias = PreferenciasUsuario();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/worker.jpg'),
                    fit: BoxFit.cover)),
          ),
          preferencias.token.isNotEmpty? ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'dashboard');
            },
          ): Container(),
          preferencias.token.isEmpty? ListTile(
            leading: Icon(Icons.login),
            title: Text('Iniciar Sesión'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'login');
            },
          ): Container(),

          preferencias.token.isEmpty? ListTile(
            leading: Icon(Icons.create),
            title: Text('Registrarse'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'registro');
            },
          ): Container(),


          preferencias.token.isEmpty? ListTile(
            leading: Icon(Icons.search_rounded),
            title: Text('Filtrar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'filtros');
            },
          ):
          ListTile(
            leading: Icon(Icons.search_rounded),
            title: Text('Filtrar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'filtros');
            },
          ),
        ],
      ),
    );
  }
}
