import 'package:flutter/material.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class MenuOpcionesPrincipalesWidget extends StatelessWidget {
  const MenuOpcionesPrincipalesWidget({Key? key}) : super(key: key);

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
          preferencias.token.isNotEmpty
              ? ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'dashboard');
                  },
                )
              : Container(),
          preferencias.token.isEmpty
              ? ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Iniciar Sesión'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'login');
                  },
                )
              : Container(),
          preferencias.token.isEmpty
              ? ListTile(
                  leading: const Icon(Icons.create),
                  title: const Text('Registrarse'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'registro');
                  },
                )
              : Container(),
          preferencias.token.isEmpty
              ? ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Filtrar'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'filtros');
                  },
                )
              : ListTile(
                  leading: const Icon(Icons.search_rounded),
                  title: const Text('Filtrar'),
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
