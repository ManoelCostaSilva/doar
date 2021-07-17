import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'adm/adm_pedidos.dart';
import 'categorias/categorias.dart';
import 'lang/translation_service.dart';
import 'categorias/categorias_lista.dart';
import 'user/user_lista.dart';


void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doar',
      routes: {
        'categorias_lista': (context) => CategoriasLista(),
        'categorias': (context) => Categorias(),
        'usuarios_lista': (context) => UserLista(),
      },
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      translations: TranslationService(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdmPedidos(),
    );
  }
}