import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart';
import 'visualitzar_productes.dart';
import 'afegir_productes.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? selectedUserId;
  String? selectedProductId;
  List<Map<String, dynamic>> selectedUserProducts = [];

  @override
  void initState() {
    super.initState();
    //Agafa tots els productes i usuaris
    Provider.of<DataProvider>(context, listen: false).fetchAllUsers();
    Provider.of<DataProvider>(context, listen: false).fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar amb el titol de preus dinamics
      appBar: AppBar(
        title: const Text('Preus Dinamics'),
      ),
      //Consumim el dataProvider per a que canvii quan canvii la informació
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.users.isEmpty || dataProvider.products.isEmpty) {
            return const CircularProgressIndicator();
          } else {
            selectedUserProducts = dataProvider.products
              .where((product) => product['usuari'].toString() == selectedUserId)
              .toList();

            // "CSS" del AppBar
            return Padding( 
              padding: const EdgeInsets.only(top: 20.0), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding( 
                        padding: const EdgeInsets.only(bottom: 20.0), 
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProductForm()),
                            );
                          },
                          child: const Text('Afegir productes'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>( 
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), 
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Botón para modificar productos
                      ElevatedButton(
                        //Va a la view de los productos al hacer click
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VisualitzarProductes()),
                          );
                        },
                        child: const Text('Modificar Productes'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>( 
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), 
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                //Segunda columna con las estadísticas
                Column(
                  children: [
                    const Text(
                      'Estadísticas',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    if (selectedUserId != null && selectedProductId != null)
                      //LLama a las estadísticas
                      FutureBuilder<Map<String, dynamic>>(
                        future: dataProvider.fetchStatistics(selectedUserId!, selectedProductId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(
                              children: <Widget>[
                                Text('Beneficios: ${double.parse(snapshot.data!['beneficios'].toString()).toStringAsFixed(2)} \$'),
                                Text('Volumen de ventas: ${snapshot.data!['total_vendidos']}'),
                              ],
                            );
                          }
                        },
                      ),
                    //Te pide los dos campos para mostrar las estadisticas segun el producto
                    if (selectedUserId == null || selectedProductId == null)
                      const Text('Por favor, selecciona un usuario y un producto'),
                  ],
                ),
                //Columna para seleccionar la tienda y el producto
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: selectedUserId,
                      onChanged: (String? newValue) {
                        setState(() {
                          //Cambia los valores del usuario y el usuario de los productos
                          selectedUserId = newValue;
                          selectedUserProducts = dataProvider.products
                            .where((product) => product['usuari'].toString() == newValue)
                            .toList();
                          selectedProductId = null;
                        });
                      },
                      items: dataProvider.users.map<DropdownMenuItem<String>>((user) {
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
                            const Text('La tienda no tiene productos')
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
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                  ],
                ),
              ],
              )
            );
          }
        },
      ),
    );
  }
}