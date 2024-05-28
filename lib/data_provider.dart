import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Gestiona todos los datos de la aplicación
class DataProvider with ChangeNotifier {
  //Listas para guardar productos y users
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _users = [];

// Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchAllUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/users/'));

//Si va todo bien 
    if (response.statusCode == 200) {
      //Pasar  id y nombre a JSON
      List<dynamic> usersJson = jsonDecode(response.body);
      _users = usersJson.map<Map<String, dynamic>>((user) {
        return {
          'id': user['id'],
          'nombre': user['nom'],
        };
      }).toList();
      //Avisa al resto de apps que los datos han cambiado
      notifyListeners();
    }
  }

  Future<void> fetchAllProducts() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/products/'));

    if (response.statusCode == 200) {
      List<dynamic> productsJson = jsonDecode(response.body);
      _products = productsJson.map<Map<String, dynamic>>((product) {
        return {
          'id': product['id'],
          'nom': product['nom'],
          'preu': product['preu'],
          'descripcio': product['descripcio'],
          'usuari': product['usuari'],
        };
      }).toList();
      notifyListeners();
    }
  }
  Future<Map<String, dynamic>> fetchStatistics(String userId, [String productId = '']) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/estadisticas/$userId/$productId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load statistics');
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

}