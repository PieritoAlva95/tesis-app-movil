import 'package:flutter/material.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key? key}) : super(key: key);

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
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('dashboard', (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.person_sharp),
            title: Text('Tus Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'tuscontratos');
            },
          ),
          ListTile(
            leading: Icon(Icons.person_sharp),
            title: Text('Mis Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'miscontratos');
            },
          ),
          ListTile(
            leading: Icon(Icons.remove_red_eye),
            title: Text('Ver Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'verperfil');
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.person_sharp),
            title: Text('Editar Perfil'),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person_sharp),
                title: Text('Datos Generales'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarperfil');
                },
              ),
              ListTile(
                leading: Icon(Icons.person_sharp),
                title: Text('Habilidades'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarhabilidad');
                },
              ),
              ListTile(
                leading: Icon(Icons.person_sharp),
                title: Text('Experiencia'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'listarexperiencia');
                },
              ),
              ListTile(
                leading: Icon(Icons.person_sharp),
                title: Text('Estudios'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'listarestudio');
                },
              ),
              ListTile(
                leading: Icon(Icons.person_sharp),
                title: Text('Redes Sociales'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarredes');
                },
              ),
            ],
          ),
          preferencias.esAdmin
              ? ListTile(
                  leading: Icon(Icons.person_sharp),
                  title: Text('Administrar Usuarios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'usuariosadmin');
                  },
                )
              : Container(),
          preferencias.esAdmin
              ? ListTile(
                  leading: Icon(Icons.person_sharp),
                  title: Text('Administrar Ofertas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'ofertasadmin');
                  },
                )
              : Container(),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Cambiar Contraseña'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'cambiarpassword');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_power_rounded),
            title: Text('Salir'),
            onTap: () {
              preferencias.clear();
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
