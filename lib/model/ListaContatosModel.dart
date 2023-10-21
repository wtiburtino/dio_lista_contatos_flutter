class ListaContatosModel {
  List<Contato> results = [];

  ListaContatosModel(this.results);

  ListaContatosModel.criar();

  ListaContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Contato>[];
      json['results'].forEach((v) {
        results.add(Contato.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contato {
  String objectId = "";
  String createdAt = "";
  String updatedAt = "";
  String nome = "";
  String email = "";
  String fotopath = "";

  Contato(this.objectId, this.createdAt, this.updatedAt, this.nome, this.email,
      this.fotopath);

  Contato.criar(this.nome, this.email, this.fotopath);

  Contato.load();

  Contato.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    nome = json['nome'];
    email = json['email'];
    fotopath = json['fotopath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['nome'] = nome;
    data['email'] = email;
    data['fotopath'] = fotopath;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['email'] = email;
    data['fotopath'] = fotopath;
    return data;
  }
}
