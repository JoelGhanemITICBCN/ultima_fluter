import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'afegir_productes.dart';

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

Future<Map<String, dynamic>> fetchStatistics(String userId, [String productId = '']) async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/estadisticas/$userId/$productId'));

  if (response.statusCode == 200) {
    // Si el servidor devuelve una respuesta OK, parseamos el JSON.
    return jsonDecode(response.body);
  } else {
    // Si la respuesta no fue OK, lanzamos un error.
    throw Exception('Failed to load statistics');
  }
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
        title: const Text('Preus Dinamics'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductForm()),
                  );
                },
                child: Text('Afegir productes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductForm()),
                  );
                },
                child: Text('Modificar Productes'),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Estadísticas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Comprueba si selectedUserId y selectedProductId son null
              if (selectedUserId != null && selectedProductId != null)
                // Si no son null, renderiza el FutureBuilder
                FutureBuilder<Map<String, dynamic>>(
                  future: fetchStatistics(selectedUserId!, selectedProductId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          Text('Beneficios: ${snapshot.data?['beneficios']}'),
                          Text('Volumen de ventas: ${snapshot.data?['total_vendidos']}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // Por defecto, muestra un spinner de carga.
                    return CircularProgressIndicator();
                  },
                ),
              // Si son null, muestra un mensaje
              if (selectedUserId == null || selectedProductId == null)
                Text('Por favor, selecciona un usuario y un producto'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (selectedProductId != null)
                      Text(
                        '${selectedUserProducts.firstWhere((product) => product['id'].toString() == selectedProductId)['preu']} \$',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}