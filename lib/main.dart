import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> products = [];
  String? selectedUserId;
  List<Map<String, dynamic>> selectedUserProducts = [];

  @override
  void initState() {
    super.initState();
    fetchAllUsers().then((value) {
      setState(() {
        users = value;
      });
    });
    fetchAllProducts().then((value) {
      setState(() {
        products = value;
      });
    });
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
        };
      }).toList();
    } else {
      throw Exception('Error al cargar los usuarios');
    }
  }

  Widget buildUsersList() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index]['nombre']),
        );
      },
    );
  }

  Widget buildProductsList() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(products[index]['nom']),
        );
      },
    );
  }

  String? selectedProductId;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedUserId,
            onChanged: (String? newValue) {
              setState(() {
                selectedUserId = newValue;
                selectedUserProducts = products
                  .where((product) => product['usuari'].toString() == newValue)
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
          if (selectedUserId != null)
            if (selectedUserProducts.isEmpty)
              Text('La tienda no tiene productos')
            else
              DropdownButton<String>(
                value: selectedProductId,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedProductId = newValue;
                  });
                },
                items: selectedUserProducts.map<DropdownMenuItem<String>>((product) {
                  return DropdownMenuItem<String>(
                    value: product['id'].toString(),
                    child: Text(product['nom']),
                  );
                }).toList(),
              ),
          Expanded(child: buildUsersList()),
          Expanded(child: buildProductsList()),
        ],
      ),
    );
  }
  }