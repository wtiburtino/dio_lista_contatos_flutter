import 'dart:io';

import 'package:dio_lista_contatos_flutter/model/ListaContatosModel.dart';
import 'package:dio_lista_contatos_flutter/repository/ListaContatosRepository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';

class ContatoPage extends StatefulWidget {
  final String contatoId;
  const ContatoPage({super.key, required this.contatoId});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  late ListaContatosRepository listaContatosRepository;
  var contato = Contato.load();
  var nomeController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  final _focusNodeNome = FocusNode();
  final _focusNodeEmail = FocusNode();
  XFile? photo;
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregarDados(widget.contatoId);
  }

  carregarDados(String contatoId) async {
    setState(() {
      carregando = true;
    });
    listaContatosRepository = ListaContatosRepository();
    if (contatoId != "") {
      contato = await listaContatosRepository.obteContato(contatoId);
    }
    nomeController.text = contato.nome;
    emailController.text = contato.email;

    if (contato.fotopath != "") {
      photo = XFile(contato.fotopath);
    }
    carregando = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: (widget.contatoId == ""
              ? const Text("Novo Contato")
              : const Text("Editar Contato")),
          backgroundColor: Colors.amberAccent,
        ),
        body: (carregando
            ? Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const CircularProgressIndicator())
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CircleAvatar(
                        radius: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipOval(
                              child: (photo == null
                                  ? const Image(
                                      image:
                                          AssetImage('assets/images/user.png'))
                                  : Image.file(File(photo!.path)))),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                photo = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (photo != null) {
                                  String path = (await path_provider
                                          .getApplicationDocumentsDirectory())
                                      .path;
                                  String name = basename(photo!.path);
                                  await photo!.saveTo("$path/$name");
                                  await GallerySaver.saveImage(photo!.path);
                                  setState(() {});
                                }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.camera,
                                color: Color.fromARGB(255, 16, 88, 38),
                              )),
                          IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                photo = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {});
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.images,
                                color: Color.fromARGB(255, 16, 88, 38),
                              ))
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            hintText: "Informe o nome",
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          focusNode: _focusNodeNome,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            hintText: "Informe o e-mail",
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          focusNode: _focusNodeEmail,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () async {
                              if (nomeController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Nome não preenchido!")));
                                return;
                              }
                              if (emailController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("E-mail não preenchido!")));
                                return;
                              }
                              contato.nome = nomeController.text;
                              contato.email = emailController.text;
                              contato.fotopath =
                                  (photo == null ? "" : photo!.path);
                              if (widget.contatoId == "") {
                                await listaContatosRepository.criar(contato);
                              } else {
                                await listaContatosRepository.atualiza(contato);
                              }
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 16, 88, 38))),
                            child: const Text(
                              "Salvar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
