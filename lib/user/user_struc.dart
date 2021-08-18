import 'dart:convert';

class UserStruc {
  String? cidadeId;
  String? cidadeNome;
  String? ufId;
  String? ufNome;
  String? fone;
  String? img;
  String? nome;
  String? status;
  String? termo;
  String? id;

  UserStruc({this.cidadeId,this.cidadeNome,this.ufId,this.ufNome,this.fone,this.img,
      this.nome,this.status,this.termo,this.id});

  factory UserStruc.fromJson(Map<String, dynamic> jsonData) {
    return UserStruc(
      cidadeId: jsonData['cidadeId'],
      cidadeNome: jsonData['cidadeNome'],
      ufId: jsonData['ufId'],
      ufNome: jsonData['ufNome'],
      fone: jsonData['fone'],
      img: jsonData['img'],
      nome: jsonData['nome'],
      status: jsonData['status'],
      termo: jsonData['termo'],
      id: jsonData['id'],
    );
  }

  static Map<String, dynamic> toMap(UserStruc user) => {
    'cidadeId': user.cidadeId,
    'cidadeNome': user.cidadeNome,
    'ufId': user.ufId,
    'ufNome': user.ufNome,
    'fone': user.fone,
    'img': user.img,
    'nome': user.nome,
    'status': user.status,
    'termo': user.termo,
    'id': user.id,
  };

  static String encode(List<UserStruc> musics) => json.encode(
    musics.map<Map<String, dynamic>>((music) => UserStruc.toMap(music)).toList(),
  );

  static List<UserStruc>? decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<UserStruc>((item) => UserStruc.fromJson(item)).toList();

}