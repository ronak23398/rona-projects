import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/product.dart';
import '../../providers/shop_provider.dart';

class ProductManagementScreen extends StatefulWidget {
  final String shopId;
  final Product? existingProduct;
  
  const ProductManagementScreen({
    super.key, 
    required this.shopId,
    this.existingProduct,
  });

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  bool _isEditing = false;
  
  final List<String> _categories = [
    'Groceries',
    'Vegetables',
    'Fruits',
    'Dairy',
    'Bakery',
    'Snacks',
    'Beverages',
    'Personal Care',
    'Household',
    'Electronics',
    'Stationery',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingProduct != null;
    
    if (_isEditing) {
      final product = widget.existingProduct!;
      _nameController.text = product.name;
      _categoryController.text = product.category;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _imageUrlController.text = product.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final shopProvider = context.read<ShopProvider>();
    
    final product = Product(
      id: _isEditing ? widget.existingProduct!.id : '',
      shopId: widget.shopId,
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      createdAt: _isEditing ? widget.existingProduct!.createdAt : DateTime.now(),
    );

    bool success;
    if (_isEditing) {
      success = await shopProvider.updateProduct(product);
    } else {
      success = await shopProvider.addProduct(product);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Product updated successfully!' : 'Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(shopProvider.error ?? 'Failed to save product'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: _isEditing ? [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _handleDeleteProduct,
          ),
        ] : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.inventory,
                  size: 60,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  _isEditing ? 'Update Product' : 'Add New Product',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Product Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    prefixIcon: const Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: _categoryController.text.isEmpty ? null : _categoryController.text,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoryController.text = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Price (₹)',
                    prefixIcon: const Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Stock
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock Quantity',
                    prefixIcon: const Icon(Icons.inventory_2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    final stock = int.tryParse(value);
                    if (stock == null || stock < 0) {
                      return 'Please enter a valid stock quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Image URL (Optional)
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'Image URL (Optional)',
                    prefixIcon: const Icon(Icons.image),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: 'Add a product image URL',
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasAbsolutePath) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Save Button
                Consumer<ShopProvider>(
                  builder: (context, shopProvider, _) {
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: shopProvider.isLoading ? null : _handleSaveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: shopProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isEditing ? 'Update Product' : 'Add Product',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDeleteProduct() async {
    if (!_isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final shopProvider = context.read<ShopProvider>();
      final success = await shopProvider.deleteProduct(widget.existingProduct!.id);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(shopProvider.error ?? 'Failed to delete product'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
