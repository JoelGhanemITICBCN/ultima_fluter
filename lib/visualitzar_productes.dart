import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'editar_productes.dart';
import 'dart:convert';

class VisualitzarProductes extends StatefulWidget {
  VisualitzarProductes({Key? key}) : super(key: key);

  @override
  _VisualitzarProductesState createState() => _VisualitzarProductesState();
}
class _VisualitzarProductesState extends State<VisualitzarProductes> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> selectedUserProducts = [];
  List<Map<String, dynamic>> users = [];
  String? selectedUserId;
  String? selectedProductId;

  @override
  void initState() {
    super.initState();
    fetchAllUsers().then((value) => setState(() {
          users = value;
        }));
    fetchAllProducts().then((value) => setState(() {
          products = value;
        }));
  }
Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/users/'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map<Map<String, dynamic>>((user) {
        return {
          'id': user['id'],
          'nombre': user['nom'],
        };
      }).toList();
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/products/'));

    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      return productsJson.map<Map<String, dynamic>>((product) {
        return {
          'id': product['id'],
          'nom': product['nom'],
          'preu': product['preu'],
          'usuari': product['usuari'],
          'descripcio': product['descripcio'],
        };
      }).toList();
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('http://127.0.0.1:8000/post/product/delete/$id/'));
    if (response.statusCode == 200) {
      fetchAllProducts();
    } else {
      throw Exception('Failed to delete product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualitzar Productes'),
        actions: [
          DropdownButton<String>(
            value: selectedUserId,
            onChanged: (String? newValue) {
              setState(() {
                selectedUserId = newValue;
                selectedUserProducts = newValue == null
                    ? products
                    : products
                        .where((product) =>
                            product['usuari'].toString() == newValue)
                        .toList();
                selectedProductId = null;
              });
            },
            items: users.map<DropdownMenuItem<String>>((user) {
              return DropdownMenuItem<String>(
                value: user['id'].toString(),
                child: Text(user['nombre']),
              );
            }).toList(),
          ),
        ],
      ),
      body: users.isEmpty || products.isEmpty
          ? CircularProgressIndicator()
          : ListView(
              children: selectedUserProducts.map((product) {
                return Card(
                  child: ListTile(
                    title: Text(product['nom']),
                    subtitle: Text('${product['preu']} \$\n${product['descripcio']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            if (product['id'] != null) {
                                print(product['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditaForm(productId: product['id'].toString(), id: product['id'])),
                              );
                            } else {
                              print('Product ID is null');
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteProduct(product['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
  }
