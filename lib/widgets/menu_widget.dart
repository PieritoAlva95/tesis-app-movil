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
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/worker.jpg'),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Ofertas Disponibles"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Panel de Control'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('dashboard', (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_sharp),
            title: const Text('Tus Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'tuscontratos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_sharp),
            title: const Text('Mis Contratos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'miscontratos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.remove_red_eye),
            title: const Text('Ver Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'verperfil');
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.person_sharp),
            title: const Text('Editar Perfil'),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_sharp),
                title: const Text('Datos Generales'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarperfil');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_sharp),
                title: const Text('Habilidades'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarhabilidad');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_sharp),
                title: const Text('Experiencia'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'listarexperiencia');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_sharp),
                title: const Text('Estudios'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'listarestudio');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_sharp),
                title: const Text('Redes Sociales'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editarredes');
                },
              ),
            ],
          ),
          preferencias.esAdmin
              ? ListTile(
                  leading: const Icon(Icons.person_sharp),
                  title: const Text('Administrar Usuarios'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'usuariosadmin');
                  },
                )
              : Container(),
          preferencias.esAdmin
              ? ListTile(
                  leading: const Icon(Icons.person_sharp),
                  title: const Text('Administrar Ofertas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'ofertasadmin');
                  },
                )
              : Container(),
          const Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Cambiar Contraseña'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'cambiarpassword');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_power_rounded),
            title: const Text('Salir'),
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
