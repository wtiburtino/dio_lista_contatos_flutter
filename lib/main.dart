import 'package:dio_lista_contatos_flutter/model/ListaContatosModel.dart';
import 'package:dio_lista_contatos_flutter/pages/contatoPage.dart';
import 'package:dio_lista_contatos_flutter/repository/ListaContatosRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Contatos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lista de Contatos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var listaContatosModel = ListaContatosModel.criar();
  late ListaContatosRepository listaContatosRepository;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    setState(() {
      carregando = true;
    });
    listaContatosRepository = ListaContatosRepository();
    listaContatosModel = await listaContatosRepository.obteContatos();
    carregando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: (carregando
            ? Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const CircularProgressIndicator())
            : (listaContatosModel.results.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Não existem contatos disponíveis !",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ))
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        itemCount: (listaContatosModel.results.length),
                        itemBuilder: (BuildContext bc, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            width: double.infinity,
                            child: Card(
                              elevation: 8,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                listaContatosModel
                                                    .results[index].nome,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                listaContatosModel
                                                    .results[index].email,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => ContatoPage(
                                                          contatoId:
                                                              listaContatosModel
                                                                  .results[
                                                                      index]
                                                                  .objectId))).then(
                                                  (value) => carregarDados());
                                            },
                                            icon: const FaIcon(
                                              FontAwesomeIcons.pencil,
                                              color: Color.fromARGB(
                                                  255, 16, 88, 38),
                                            )),
                                        IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Excluir contato ?"),
                                                      actions: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              carregando = true;
                                                              Navigator.pop(
                                                                  context);
                                                              await listaContatosRepository.remover(
                                                                  listaContatosModel
                                                                      .results[
                                                                          index]
                                                                      .objectId);
                                                              carregarDados();
                                                            },
                                                            child: const Text(
                                                                "Sim")),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Não"))
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const FaIcon(
                                                FontAwesomeIcons.trash,
                                                color: Color.fromARGB(
                                                    255, 16, 88, 38)))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.pop(context);
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (bc) => const ContatoPage(contatoId: "")))
              .then((value) => carregarDados());
        },
        tooltip: 'Adicionar contato',
        child: const FaIcon(FontAwesomeIcons.personCirclePlus),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
