import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/pages/agregar.estudios.page.dart';
import 'package:jobsapp/pages/agregar.experiencia.page.dart';
import 'package:jobsapp/pages/cambiar.password.page.dart';
import 'package:jobsapp/pages/crear.ofertas.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/pages/editar.estu.page.dart';
import 'package:jobsapp/pages/editar.experiencia.page.dart';
import 'package:jobsapp/pages/listar.estudio.page.dart';
import 'package:jobsapp/pages/listar.experiencia.page.dart';
import 'package:jobsapp/pages/editar.habilidad.page.dart';
import 'package:jobsapp/pages/editar.oferta.dart';
import 'package:jobsapp/pages/editar.perfil.page.dart';
import 'package:jobsapp/pages/editar.redes.page.dart';
import 'package:jobsapp/pages/home.page.dart';
import 'package:jobsapp/pages/home.page.filtros.dart';
import 'package:jobsapp/pages/lista.ofertas.admin.dart';
import 'package:jobsapp/pages/lista.usuarios.admin.dart';
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/pages/misContratos.page.dart';
import 'package:jobsapp/pages/perfil.page.dart';
import 'package:jobsapp/pages/postular.oferta.dart';
import 'package:jobsapp/pages/registro.page.dart';
import 'package:jobsapp/pages/tuscontratos.page.dart.dart';
import 'package:jobsapp/pages/ver.editar.oferta.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/createMaterialColor.dart';
import 'package:jobsapp/widgets/filtro.busqueda.widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final preferencias = PreferenciasUsuario();
  await preferencias.initPreferencias();
  print('PREFERENCIA TOKEN: ${preferencias.token}');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Trabajos 24/7',
        initialRoute: 'home',
        themeMode: ThemeMode.dark,
        routes: {
          'login': (BuildContext) => const LoginPage(),
          'home': (BuildContext) => const HomePage(),
          'homefiltros': (BuildContext) => const HomeFiltrosPage(),
          'registro': (BuildContext) => const RegistroUsuarios(),
          'dashboard': (BuildContext) => const DashboardPage(),
          'crearoferta': (BuildContext) => const CrearOfertaPage(),
          'editaroferta': (BuildContext) => const EditarOfertaPage(),
          'vereditaroferta': (BuildContext) => const VerEditarOerta(),
          'tuscontratos': (BuildContext) => const TusContratosPage(),
          'miscontratos': (BuildContext) => const MisContratosPage(),
          'verperfil': (BuildContext) => const PerfilPage(),
          'editarperfil': (BuildContext) => const EditarPerfilPage(),
          'editarhabilidad': (BuildContext) => const EditarHabilidadPage(),
          'listarexperiencia': (BuildContext) => const ListarExperienciaPage(),
          'agregarexperiencia': (BuildContext) =>
              const AgregarExperienciaPage(),
          'editarexperiencia': (BuildContext) => const EditExpPage(),
          'listarestudio': (BuildContext) => const ListarEstudioPage(),
          'agregarestudio': (BuildContext) => const AgregarEstudiosPage(),
          'editarestudio': (BuildContext) => const EditEstuPage(),
          'editarredes': (BuildContext) => const EditarRedesPage(),
          'cambiarpassword': (BuildContext) => const CambiarPasswordPage(),
          'postular': (BuildContext) => const PostularOferta(),
          'filtros': (BuildContext) => const FiltroBusquedaWidget(),
          'usuariosadmin': (BuildContext) => const UsuariosAdministrador(),
          'ofertasadmin': (BuildContext) => const OfertasAdministrador(),
        },
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(53, 80, 112, 1.0),
          primarySwatch:
              createMaterialColor.createMaterialColor(const Color(0xFF355070)),
        ),
      ),
    );
  }
}
