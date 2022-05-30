import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/pages/cambiar.password.page.dart';
import 'package:jobsapp/pages/crear.ofertas.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/pages/edit.exp.page.dart';
import 'package:jobsapp/pages/editar.estudio.page.dart';
import 'package:jobsapp/pages/editar.experiencia.page.dart';
import 'package:jobsapp/pages/editar.habilidad.page.dart';
import 'package:jobsapp/pages/editar.oferta.dart';
import 'package:jobsapp/pages/editar.perfil.page.dart';
import 'package:jobsapp/pages/editar.redes.page.dart';
import 'package:jobsapp/pages/home.page.dart';
import 'package:jobsapp/pages/home.page.filtros.dart';
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/pages/misContratos.page.dart';
import 'package:jobsapp/pages/perfil.page.dart';
import 'package:jobsapp/pages/postular.oferta.dart';
import 'package:jobsapp/pages/pruebas/page.one.dart';
import 'package:jobsapp/pages/registro.page.dart';
import 'package:jobsapp/pages/tuscontratos.page.dart.dart';
import 'package:jobsapp/pages/ver.editar.oferta.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/createMaterialColor.dart';
import 'package:jobsapp/widgets/filtro.busqueda.widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = PreferenciasUsuario();
  await preferencias.initPreferencias();
  print('PREFERENCIA ${preferencias.token}');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final createMaterialColor = CreateMaterialColor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    //final prefs = PreferenciasUsuario();
    //print('PREFERENCIA ${prefs.token}');
    return Provider(
      child:
      MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
          ],
      debugShowCheckedModeBanner: false,
      title: 'Trabajos 24/7',
      initialRoute: 'home',
      themeMode: ThemeMode.dark,
      routes: {
        'login': (BuildContext) => LoginPage(),
        'home': (BuildContext) => HomePage(),
        'homefiltros': (BuildContext) => HomeFiltrosPage(),
        'registro': (BuildContext) => RegistroUsuarios(),
        'dashboard': (BuildContext) => DashboardPage(),
        'crearoferta': (BuildContext) => CrearOfertaPage(),
        'editaroferta': (BuildContext) => EditarOfertaPage(),
        'vereditaroferta': (BuildContext) => VerEditarOerta(),
        'tuscontratos': (BuildContext) => TusContratosPage(),
        'miscontratos': (BuildContext) => MisContratosPage(),
        'verperfil': (BuildContext) => PerfilPage(),
        'editarperfil': (BuildContext) => EditarPerfilPage(),
        'editarhabilidad': (BuildContext) => EditarHabilidadPage(),
        'editarexperiencia': (BuildContext) => EditarExperienciaPage(),
        'editarestudio': (BuildContext) => EditarEstudioPage(),
        'editarredes': (BuildContext) => EditarRedesPage(),
        'cambiarpassword': (BuildContext) => CambiarPasswordPage(),
        'postular': (BuildContext) => PostularOferta(),
        'filtros': (BuildContext) => FiltroBusquedaWidget(),

        'editexp': (BuildContext) => EditExpPage(),
        
      },
      theme: ThemeData(
        primaryColor: Color.fromRGBO(53, 80, 112, 1.0),
        primarySwatch: createMaterialColor.createMaterialColor(Color(0xFF355070)),
        
      ),
    ) 
      );
  }
}