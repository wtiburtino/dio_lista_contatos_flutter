import 'package:dio/dio.dart';
import 'package:dio_lista_contatos_flutter/model/ListaContatosModel.dart';

class ListaContatosRepository {
  var _dio = Dio();

  ListaContatosRepository() {
    _dio.options.headers["X-Parse-Application-Id"] = "";
    _dio.options.headers["X-Parse-REST-API-Key"] = "";
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = "https://parseapi.back4app.com/classes";
  }

  Future<ListaContatosModel> obteContatos() async {
    var url = "/listacontatos";
    var response = await _dio.get(url);
    if (response.statusCode == 200) {
      return ListaContatosModel.fromJson(response.data);
    }
    return ListaContatosModel.criar();
  }

  Future<Contato> obteContato(String contatoId) async {
    var url = "/listacontatos/$contatoId";
    var response = await _dio.get(url);
    if (response.statusCode == 200) {
      return Contato.fromJson(response.data);
    }
    return Contato.load();
  }

  Future<void> criar(Contato contato) async {
    await _dio.post("/listacontatos", data: contato.toJsonEndpoint());
  }

  Future<void> atualiza(Contato contato) async {
    await _dio.put("/listacontatos/${contato.objectId}",
        data: contato.toJsonEndpoint());
  }

  Future<void> remover(String objectId) async {
    await _dio.delete("/listacontatos/$objectId");
  }
}
