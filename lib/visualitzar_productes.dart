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
  //Listas para guardar los valores
  List<Map<String, dynamic>> selectedUserProducts = [];
  String? selectedUserId;
  String? selectedProductId;

  @override
  void initState() {
    super.initState();
    //Llama a las funciones para tener las tiendas y los productos
    Provider.of<DataProvider>(context, listen: false).fetchAllUsers();
    Provider.of<DataProvider>(context, listen: false).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    //Hace la barra con el titulo de visualizar productos
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualitzar Productes'),
      ),
      //Consume el dataProvider para que cambie cuando cambien los datos
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.users.isEmpty || dataProvider.products.isEmpty) {
            return CircularProgressIndicator();
          } else {
            //Muestra los productos en una lista
            return ListView(
              children: dataProvider.products.map((product) {
                return Card(
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        //Te manda a modifiucar el producto si clickas sobre el nombre
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
                        //Icono de agregar ventas 
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green), 
                          onPressed: () {
                            if (product['id'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddSaleScreen(productId: product['id'])),
                              );
                            } else {
                              print('El ID del producto no es valido');
                            }
                          },
                        ),
                        //Icono de editar producto
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.yellow), 
                          onPressed: () {
                            if (product['id'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditaForm(productId: product['id'].toString(), id: product['id'])),
                              );
                            } else {
                              print('El ID del producto no es valido');
                            }
                          },
                        ),
                        //Icono de borrar producto
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