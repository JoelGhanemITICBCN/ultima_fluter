//LO dejo a medias por ahora que creo que es mas necesario el homeview, falta dejar bien lo de la introd. de campos
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductForm extends StatefulWidget {
  final int? id;

  const ProductForm({super.key, this.id});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _descripcioController = TextEditingController();
  final _quantitatController = TextEditingController();
  final _preuController = TextEditingController();
  final _costController = TextEditingController();
  final _preuMaximController = TextEditingController();
  final _preuMinimController = TextEditingController();
  final _multiplicadorRestaController = TextEditingController();
  final _multiplicadorSumaController = TextEditingController();
  final _usuariController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _numCompresController = TextEditingController();
  final _fotoController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      addProducte();
    }
  }

  Future<void> addProducte() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/post/product/add/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _nomController.text = data['nom'];
      _descripcioController.text = data['descripcio'];
      _quantitatController.text = data['quantitat'].toString();
      _preuController.text = data['preu'].toString();
      _costController.text = data['cost'].toString();
      _preuMaximController.text = data['preu_maxim'].toString();
      _preuMinimController.text = data['preu_minim'].toString();
      _multiplicadorRestaController.text =
          data['multiplicador_resta'].toString();
      _multiplicadorSumaController.text = data['multiplicador_suma'].toString();
      _usuariController.text = data['usuari'].toString();
      _categoriaController.text = data['categoria'].toString();
      _numCompresController.text = data['num_compres'].toString();
    } else {
      throw Exception('Has fet alguna cosa malament!');
    }
  }
  
  Future<void> saveData() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/post/product/add/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nom': _nomController.text,
          'descripcio': _descripcioController.text,
          'quantitat': int.parse(_quantitatController.text),
          'preu': double.parse(_preuController.text),
          'cost': double.parse(_costController.text),
          'preu_maxim': double.parse(_preuMaximController.text),
          'preu_minim': double.parse(_preuMinimController.text),
          'multiplicador_resta': double.parse(_multiplicadorRestaController.text),
          'multiplicador_suma': double.parse(_multiplicadorSumaController.text),
          'usuari': int.parse(_usuariController.text),
          'categoria': int.parse(_categoriaController.text),
          'num_compres': int.parse(_numCompresController.text),
        }),
      );
      if (response.statusCode == 201) {
      } else {
        throw Exception('No s ha guardat');
      }
    } else {
      print('Form is not valid. Not saving data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcioController,
                decoration: const InputDecoration(
                  labelText: 'Descripcio',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica una descripcio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantitatController,
                decoration: const InputDecoration(
                  labelText: 'Quantitat',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica una quantitat';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _preuController,
                decoration: const InputDecoration(
                  labelText: 'Preu',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un preu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Cost',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _preuMaximController,
                decoration: const InputDecoration(
                  labelText: 'Preu Maxim',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un preu maxim';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _preuMinimController,
                decoration: const InputDecoration(
                  labelText: 'Preu Minim',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un preu minim';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _multiplicadorRestaController,
                decoration: const InputDecoration(
                  labelText: 'Multiplicador Resta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un multiplicador resta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _multiplicadorSumaController,
                decoration: const InputDecoration(
                  labelText: 'Multiplicador Suma',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indica un multiplicador suma';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usuariController,
                decoration: const InputDecoration(
                  labelText: 'Usuari',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introdueix un usuari';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introdueix una categoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numCompresController,
                decoration: const InputDecoration(
                  labelText: 'Num Compres',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                     return 'Introdueix una quantitat de compres';
                  }
                  return null;
                },
              ),
               ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveData();
                  }
                },
                child: Text('Afegeix el Producte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
