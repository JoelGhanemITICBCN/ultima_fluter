import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editar_productes.dart';
import 'data_provider.dart';
import 'afegir_venda.dart';

class VisualitzarProductes extends StatefulWidget {
  VisualitzarProductes({Key? key}) : super(key: key);

  @override
  _VisualitzarProductesState createState() => _VisualitzarProductesState();
}

class _VisualitzarProductesState extends State<VisualitzarProductes> {
  List<Map<String, dynamic>> selectedUserProducts = [];
  String? selectedUserId;
  String? selectedProductId;

  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchAllUsers();
    Provider.of<DataProvider>(context, listen: false).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualitzar Productes'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.users.isEmpty || dataProvider.products.isEmpty) {
            return CircularProgressIndicator();
          } else {
            return ListView(
              children: dataProvider.products.map((product) {
                return Card(
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        if (product['id'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditaForm(productId: product['id'].toString(), id: product['id'])),
                          );
                        } else {
                        }
                      },
                      child: Text(product['nom']),
                    ),
                    subtitle: Text('${product['preu']} \$\n${product['descripcio']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green), // Green add icon
                          onPressed: () {
                            if (product['id'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddSaleScreen(productId: product['id'])),
                              );
                            } else {
                              print('Product ID is null');
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.yellow), // Yellow edit icon
                          onPressed: () {
                            if (product['id'] != null) {
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
                          icon: Icon(Icons.delete, color: Colors.red), 
                          onPressed: () {
                            Provider.of<DataProvider>(context, listen: false).deleteProduct(product['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}