
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditaForm extends StatefulWidget {
  final int? id;
  final String productId;

  EditaForm({required this.productId, this.id});

  @override
  _EditaFormState createState() => _EditaFormState();
}

class _EditaFormState extends State<EditaForm> {
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

  @override
  void initState() {
    super.initState();
    print('Product ID: ${widget.id}');
    if (widget.id != null) {
      getProductData();
    }
  }

  Future<void> getProductData() async {
    print('Fetching product data...');
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/post/product/${widget.id}/'));
    if (response.statusCode == 200) {
      print('Product data fetched successfully.');
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
      print('Failed to fetch product data. Status code: ${response.statusCode}');
      throw Exception('Has fet alguna cosa malament!');
    }
  }

  Future<void> saveData() async {
    if (_formKey.currentState!.validate()) {
      print('Saving data...');
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/post/product/update/${widget.id}/'),
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
      if (response.statusCode == 200) {
        print('Data updated successfully.');
      } else {
        print('Failed to update data. Status code: ${response.statusCode}');
        throw Exception('Failed to post data');
      }
    } else {
      print('Form is not valid. Not saving data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("llegua a editaProductes");
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
                    return 'Please enter a descripcio';
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
                    return 'Please enter a preu maxim';
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
                    return 'Please enter a preu minim';
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
                    return 'Please enter a multiplicador resta';
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
                    return 'Please enter a multiplicador suma';
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
                    return 'Please enter a usuari';
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
                    return 'Please enter a categoria';
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
                    return 'Please enter a num compres';
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
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}