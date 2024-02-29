import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();


  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _imageController.dispose();
    _unitPriceController.dispose();
    _quantityController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }


  //post
  Future<void> addNewProduct() async {
    setState(() {
      _isLoading = true;
    });
    final requestData = {
      'Img': _imageController.text.trim(),
      'ProductCode': _productCodeController.text.trim(),
      'ProductName': _productNameController.text.trim(),
      'Qty': _quantityController.text.trim(),
      'TotalPrice': _totalPriceController.text.trim(),
      'UnitPrice': _unitPriceController.text.trim(),
    };

    final url = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');
    var response = await http.post(
      url,
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      _imageController.clear();
      _productCodeController.clear();
      _productNameController.clear();
      _quantityController.clear();
      _totalPriceController.clear();
      _unitPriceController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product added successfully')));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        title: const Text('Add new product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                    hintText: 'Product name',
                    labelText: 'Product name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _productCodeController,
                  decoration: const InputDecoration(
                    hintText: 'Product code',
                    labelText: 'Product code',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your product code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                    labelText: 'Image',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your image URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _unitPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Unit price',
                    labelText: 'Unit price',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the unit price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _totalPriceController,
                  decoration: const InputDecoration(
                    hintText: 'Total price',
                    labelText: 'Total price',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the total price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Add your logic here
                        addNewProduct();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[500],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: Colors.white),
                    child: _isLoading
                        ? const SizedBox(
                            // Wrap CircularProgressIndicator in SizedBox to customize its size
                            height: 24,
                            // Adjust the size of the CircularProgressIndicator
                            width: 24,
                            // Adjust the size of the CircularProgressIndicator
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth:
                                  3, // Adjust the thickness of the CircularProgressIndicator
                            ),
                          )
                        : const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
