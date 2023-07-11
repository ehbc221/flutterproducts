import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productstore/product/create_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  void testFunc1(int a, int b) {}

  void testFunc2([int? a]) {}

  void testFunc2_1([int a = 0]) {}

  void testFunc3({int? a}) {}

  void testFunc3_1({required int a}) {}

  void testFunc4() {}

  void testFunc5() {}

  void appel() {
    int a = 0;
    int b = 1;
    testFunc1(a, b);

    testFunc2();
    testFunc2(a);

    testFunc2_1();
    testFunc2_1(a);

    testFunc3();
    testFunc3(a: a);
  }

  // Future<any>
  Future<dynamic> getListProducts() async {
    // TODO Get list products
    var url = Uri.https('fakestoreapi.com', 'products');
    // var response = await http.get(url, headers: {'content-type': 'application/json'}); // TODO auth JWT
    await Future.delayed(const Duration(seconds: 1));
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

    // print(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Précédent
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        title: const Text('Products Screen'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          /*const SizedBox(
            width: 10,
          ),*/
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateProductScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text('Voici la liste des produits:'),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[300]),
                width: double.infinity,
                child: FutureBuilder<dynamic>(
                  future: getListProducts(),
                  builder: (context, snapshot) {
                    // Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    // Error
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Text('Une erreur est survenue');
                    }
                    // Success
                    // if (snapshot.hasData && snapshot.data != null)
                    // return const Text('Il y a des Données');
                    var response = jsonDecode(snapshot.data.body);
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Image.network(response[index]['image']),
                          ),
                          title: Text(response[index]['title']),
                          subtitle: Text('Prix: ${response[index]['price']}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            /*Container(
            height: 1000,

          ),
          Container(
            height: 1000,

          ),
          Container(
            height: 1000,

          ),
          Container(
            height: 1000,

          ),
          Container(
            height: 1000,

          ),*/
          ],
        ),
      ),
    );
  }
}
