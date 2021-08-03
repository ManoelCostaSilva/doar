import 'package:http/http.dart' as http;

import 'get_cidades.dart';

class Municipios {
  static getMunicipio({String? municipio}) async {
    final response = await http.get(Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados/$municipio/municipios?orderBy=nome'));
    if (response.statusCode == 200) {
      var cid=await GetCidadesFromJson(response.body);
      return cid;
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
