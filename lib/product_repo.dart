import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductRepoPage extends StatefulWidget {
  @override
  _ProductRepoPageState createState() => _ProductRepoPageState();
}

class _ProductRepoPageState extends State<ProductRepoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  final _priceController = TextEditingController();
  bool _inStock = false;

  void _addOrUpdateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final color = _colorController.text;
    final price = int.tryParse(_priceController.text) ?? 0;
    final inStock = _inStock;

    final docRef = FirebaseFirestore.instance.collection('products').doc(name);

    try {
        await docRef.set({
          'Name': name,
          'color': color,
          'price': price,
          'inStock': inStock,
        });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added/updated successfully')),
      );
      _nameController.clear();
      _colorController.clear();
      _priceController.clear();
      setState(() {
        _inStock = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add/update product')),
      );
    }
  }

  void _deleteProduct() async {
    final name = _nameController.text;
    final docRef = FirebaseFirestore.instance.collection('products').doc(name);

    try {
      await docRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
      _nameController.clear();
      _colorController.clear();
      _priceController.clear();
      setState(() {
        _inStock = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Product Repository')),
        body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    TextFormField(
    controller: _nameController,
    decoration: InputDecoration(labelText: 'Name'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter a name';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _colorController,
    decoration: InputDecoration(labelText: 'Color'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter a color';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _priceController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: 'Price'),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Please enter a price';
    }
    final price = int.tryParse(value);
    if (price == null || price <= 0) {
    return 'Please enter a valid price';
    }
    return null;
    },
    ),
      SwitchListTile(
        title: Text('In Stock'),
        value: _inStock,
        onChanged: (value) {
          setState(() {
            _inStock = value;
          });
        },
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _addOrUpdateProduct,
            child: Text('Update'),
          ),
          ElevatedButton(
            onPressed: _deleteProduct,
            child: Text('Delete'),
          ),
        ],
      ),
    ],
    ),
    ),
        ),
    );
  }
}
