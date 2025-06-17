import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fsc_management/widgets/custom_navBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fsc_management/database/db_helper.dart';

class AddproductState extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddproductState> {
  final DbHelper _dbHelper = DbHelper();

  final _formKey = GlobalKey<FormState>();
  //controllers to hold the input values
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      double price = double.parse(_priceController.text);
      int stock = int.parse(_stockController.text);

      // Save to DB
      await _dbHelper.addProduct(
        name: name,
        price: price,
        stock: stock,
        imagePath: _image?.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Product $name added Successfully"),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Clear the form
      _nameController.clear();
      _priceController.clear();
      _stockController.clear();
      setState(() {
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_bag, size: 48, color: Colors.black),
                        SizedBox(height: 10),
                        Text(
                          'Product Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Form Fields Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Product Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Product Name",
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(
                              Icons.inventory_2,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter product name' : null,
                        ),

                        SizedBox(height: 16),

                        // Price Field
                        TextFormField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter product price' : null,
                        ),

                        SizedBox(height: 16),

                        // Stock Field
                        TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(
                              Icons.storage,
                              color: Colors.black,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter stock quantity' : null,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Image Section Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Product Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 15),

                        // Image Display Container
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(_image!, fit: BoxFit.cover),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'No Image Selected',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        SizedBox(height: 15),

                        // Pick Image Button
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.photo_library),
                          label: Text('Pick Image from Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Submit Button
                Container(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitProduct,
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      shadowColor: Colors.grey[400],
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
