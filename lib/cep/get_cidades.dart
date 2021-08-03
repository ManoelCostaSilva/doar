// To parse this JSON data, do
//
//     final GetCidades = GetCidadesFromJson(jsonString);

import 'dart:convert';

List<GetCidades> GetCidadesFromJson(String str) => List<GetCidades>.from(json.decode(str).map((x) => GetCidades.fromJson(x)));

String GetCidadesToJson(List<GetCidades> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCidades {
  GetCidades({
    this.id,
    this.nome,
    this.microrregiao,
    this.regiaoImediata,
  });

  int? id;
  String? nome;
  Microrregiao? microrregiao;
  RegiaoImediata? regiaoImediata;

  factory GetCidades.fromJson(Map<String, dynamic> json) => GetCidades(
    id: json["id"],
    nome: json["nome"],
    microrregiao: Microrregiao.fromJson(json["microrregiao"]),
    regiaoImediata: RegiaoImediata.fromJson(json["regiao-imediata"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "microrregiao": microrregiao!.toJson(),
    "regiao-imediata": regiaoImediata!.toJson(),
  };
}

class Microrregiao {
  Microrregiao({
    this.id,
    this.nome,
    this.mesorregiao,
  });

  int? id;
  String? nome;
  Mesorregiao? mesorregiao;

  factory Microrregiao.fromJson(Map<String, dynamic> json) => Microrregiao(
    id: json["id"],
    nome: json["nome"],
    mesorregiao: Mesorregiao.fromJson(json["mesorregiao"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "mesorregiao": mesorregiao!.toJson(),
  };
}

class Mesorregiao {
  Mesorregiao({
    this.id,
    this.nome,
    this.uf,
  });

  int? id;
  MesorregiaoNome? nome;
  Uf? uf;

  factory Mesorregiao.fromJson(Map<String, dynamic> json) => Mesorregiao(
    id: json["id"],
    nome: mesorregiaoNomeValues.map[json["nome"]],
    uf: Uf.fromJson(json["UF"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": mesorregiaoNomeValues.reverse[nome],
    "UF": uf!.toJson(),
  };
}

enum MesorregiaoNome { SUL_FLUMINENSE, NOROESTE_FLUMINENSE, BAIXADAS, CENTRO_FLUMINENSE, METROPOLITANA_DO_RIO_DE_JANEIRO, NORTE_FLUMINENSE, RIO_DE_JANEIRO, CAMPOS_DOS_GOYTACAZES, MACA_RIO_DAS_OSTRAS_CABO_FRIO, PETRPOLIS, VOLTA_REDONDA_BARRA_MANSA }

final mesorregiaoNomeValues = EnumValues({
  "Baixadas": MesorregiaoNome.BAIXADAS,
  "Campos dos Goytacazes": MesorregiaoNome.CAMPOS_DOS_GOYTACAZES,
  "Centro Fluminense": MesorregiaoNome.CENTRO_FLUMINENSE,
  "Macaé - Rio das Ostras - Cabo Frio": MesorregiaoNome.MACA_RIO_DAS_OSTRAS_CABO_FRIO,
  "Metropolitana do Rio de Janeiro": MesorregiaoNome.METROPOLITANA_DO_RIO_DE_JANEIRO,
  "Noroeste Fluminense": MesorregiaoNome.NOROESTE_FLUMINENSE,
  "Norte Fluminense": MesorregiaoNome.NORTE_FLUMINENSE,
  "Petrópolis": MesorregiaoNome.PETRPOLIS,
  "Rio de Janeiro": MesorregiaoNome.RIO_DE_JANEIRO,
  "Sul Fluminense": MesorregiaoNome.SUL_FLUMINENSE,
  "Volta Redonda - Barra Mansa": MesorregiaoNome.VOLTA_REDONDA_BARRA_MANSA
});

class Uf {
  Uf({
    this.id,
    this.sigla,
    this.nome,
    this.regiao,
  });

  int? id;
  Sigla? sigla;
  UfNome? nome;
  Uf? regiao;

  factory Uf.fromJson(Map<String, dynamic> json) => Uf(
    id: json["id"],
    sigla: siglaValues.map[json["sigla"]],
    nome: ufNomeValues.map[json["nome"]],
    regiao: json["regiao"] == null ? null : Uf.fromJson(json["regiao"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sigla": siglaValues.reverse[sigla],
    "nome": ufNomeValues.reverse[nome],
    "regiao": regiao == null ? null : regiao!.toJson(),
  };
}

enum UfNome { RIO_DE_JANEIRO, SUDESTE }

final ufNomeValues = EnumValues({
  "Rio de Janeiro": UfNome.RIO_DE_JANEIRO,
  "Sudeste": UfNome.SUDESTE
});

enum Sigla { RJ, SE }

final siglaValues = EnumValues({
  "RJ": Sigla.RJ,
  "SE": Sigla.SE
});

class RegiaoImediata {
  RegiaoImediata({
    this.id,
    this.nome,
    this.regiaoIntermediaria,
  });

  int? id;
  String? nome;
  Mesorregiao? regiaoIntermediaria;

  factory RegiaoImediata.fromJson(Map<String, dynamic> json) => RegiaoImediata(
    id: json["id"],
    nome: json["nome"],
    regiaoIntermediaria: Mesorregiao.fromJson(json["regiao-intermediaria"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "regiao-intermediaria": regiaoIntermediaria!.toJson(),
  };
}

class EnumValues<T> {
  late Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
