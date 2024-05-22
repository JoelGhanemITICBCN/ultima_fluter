import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchAllUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/post/users/'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      _users = usersJson.map<Map<String, dynamic>>((user) {
        return {
          'id': user['id'],
          'nombre': user['nom'],
        };
      }).toList();
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
        };
      }).toList();
      notifyListeners();
    }
  }
}