import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'adm/adm_pedidos.dart';
import 'categorias/categorias.dart';
import 'doacao/doacao_solicitada.dart';
import 'doacao/minhas_doacoes.dart';
import 'lang/translation_service.dart';
import 'categorias/categorias_lista.dart';
import 'user/user_anuncio.dart';
import 'user/user_lista.dart';
import 'user/user_perfil.dart';

void main() async{
  await GetStorage.init('user');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doar',
      routes: {
        'categorias_lista': (context) => CategoriasLista(),
        'categorias': (context) => Categorias(),
        'usuarios_lista': (context) => UserLista(),
        'user_anuncio': (context) => UserAnuncio(),
        'minhas_doacoes': (context) => MinhasDoacoes(),
        'doacoes_solicitadas': (context) => DoacoesSolicitadas(),
        'perfil': (context) => UserPerfil(),
      },
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
      ),//arguments: {'tipo':'doacao'}
      //SÓ PEDE PRA AUTENTICAR QUANDO VAI FAZER UMA DOAÇÃO
      home: AdmPedidos(),
    );
  }
}