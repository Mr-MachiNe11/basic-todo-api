import 'dart:convert';

import 'package:basic_todo/screens/add_new_product.dart';
import 'package:basic_todo/screens/update_product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/product.dart';

enum MenuValues { edit, delete }

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> productList = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getProductList();
        },
        child: Visibility(
          visible: _isLoading == false,
          replacement: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final products = productList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(products.img ?? 'Unknown'),
                  radius: 25,
                ),
                title: Text(
                  products.productName ?? 'Unknown',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Wrap(
                  spacing: 16,
                  children: [
                    Text(
                      'Product code: ${products.productCode}',
                    ),
                    Text(
                      'Unit price: ${products.unitPrice}',
                    ),
                    Text(
                      'Quantity: ${products.qty}',
                    ),
                    Text(
                      'Total Price: ${products.totalPrice}',
                    ),
                  ],
                ),
                trailing: PopupMenuButton<MenuValues>(
                  onSelected: (value) {
                    onTapPopUpMenuButton(value, productList[index]);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<MenuValues>(
                      value: MenuValues.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<MenuValues>(
                      value: MenuValues.delete,
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewProduct(),
              ));
        },
        backgroundColor: Colors.purple[500],
        label: const Text(
          'Add',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }


  //get
  Future<void> getProductList() async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      productList.clear();
      final jsonData = jsonDecode(response.body);
      final list = jsonData['data'];
      for (var item in list) {
        Product product = Product.fromJson(item);
        productList.add(product);
      }
    } else {
      throw Exception('Failed to load products');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId');
    final response = await http.get(url);
    print(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //getProductList();
      productList.removeWhere((element) => element.id == productId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product delete failed! Try again.')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> onTapPopUpMenuButton(MenuValues values, Product product) async {
    switch (values) {
      case MenuValues.edit:
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateProduct(
                product: product,
              ),
            ));
        if (result != null && result == true) {
          getProductList();
        }
        break;
      case MenuValues.delete:
        showDeleteDialog(product.id!);
        break;
    }
  }

  void showDeleteDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure, you want to delete this product?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  _deleteProduct(productId);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Yes, Delete',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        );
      },
    );
  }
}
