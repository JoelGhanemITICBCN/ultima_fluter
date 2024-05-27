import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'visualitzar_productes.dart';

class AddSaleScreen extends StatefulWidget {
  final int productId;

  AddSaleScreen({required this.productId});

  @override
  _AddSaleScreenState createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();

  Future<void> _addSale() async {
    if (_formKey.currentState!.validate()) {
      final quantitat = int.parse(_quantityController.text);

      try {
        await _callApi('http://127.0.0.1:8000/post/sale/add/', {
          'quantitat': quantitat,
          'producte': widget.productId,
        });

        await _callApi('http://127.0.0.1:8000/post/product/Dpreu/${widget.productId}/', {});

        await _callApi('http://127.0.0.1:8000/post/product/${widget.productId}/save/', {});
 Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VisualitzarProductes()),
      );
      } catch (e) {
        print('Ocurrió un error al llamar a la API: $e');
      }
    }
  }

  Future<void> _callApi(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Error al contactar con la API. Código de estado: ${response.statusCode}. Respuesta: ${response.body}');
      throw Exception('Error al contactar con la API');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Afegeix vendes'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantitat'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introdueix la quantitat de vendes';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _addSale,
              child: Text('Afegeix les vendes'),
            ),
          ],
        ),
      ),
    );
  }
}