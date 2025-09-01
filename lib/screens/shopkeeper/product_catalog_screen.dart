import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/predefined_product.dart';
import '../../models/product.dart';
import '../../providers/shop_provider.dart';

class ProductCatalogScreen extends StatefulWidget {
  final String shopId;
  
  const ProductCatalogScreen({super.key, required this.shopId});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<PredefinedProduct> _filteredProducts = ProductCatalog.products;
  final Set<String> _selectedProducts = {};
  final Map<String, double> _customPrices = {}; // Store custom prices for selected products

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      List<PredefinedProduct> products = ProductCatalog.products;
      
      // Filter by category
      if (_selectedCategory != 'All') {
        products = products.where((p) => p.category == _selectedCategory).toList();
      }
      
      // Filter by search query
      final query = _searchController.text.toLowerCase();
      if (query.isNotEmpty) {
        products = products.where((p) => 
          p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query) ||
          (p.description?.toLowerCase().contains(query) ?? false)
        ).toList();
      }
      
      _filteredProducts = products;
    });
  }

  Future<void> _addSelectedProducts() async {
    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final shopProvider = context.read<ShopProvider>();
    int successCount = 0;
    int totalCount = _selectedProducts.length;

    for (String productName in _selectedProducts) {
      final predefinedProduct = ProductCatalog.products
          .firstWhere((p) => p.name == productName);
      
      // Use custom price if set, otherwise use suggested price
      final finalPrice = _customPrices[productName] ?? predefinedProduct.suggestedPrice;
      
      final product = Product(
        id: '',
        shopId: widget.shopId,
        name: predefinedProduct.name,
        category: predefinedProduct.category,
        price: finalPrice,
        stock: 10, // Default stock
        imageUrl: predefinedProduct.imageUrl,
        createdAt: DateTime.now(),
      );

      final success = await shopProvider.addProduct(product);
      if (success) {
        successCount++;
      }
    }

    if (mounted) {
      if (successCount == totalCount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully added $successCount products!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $successCount of $totalCount products'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _showPriceEditDialog(PredefinedProduct product) async {
    final currentPrice = _customPrices[product.name] ?? product.suggestedPrice;
    
    final result = await showDialog<double>(
      context: context,
      builder: (context) => _PriceEditDialog(
        product: product,
        initialPrice: currentPrice,
      ),
    );

    if (result != null) {
      setState(() {
        _customPrices[product.name] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...ProductCatalog.categories];

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Product Catalog'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedProducts.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_selectedProducts.length} selected',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = category == _selectedCategory;
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                              _filterProducts();
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Colors.green.shade100,
                          checkmarkColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Products List
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      final isSelected = _selectedProducts.contains(product.name);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: isSelected ? 4 : 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected 
                                ? Border.all(color: Colors.green, width: 2)
                                : null,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Text(
                                product.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category: ${product.category}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (product.description != null)
                                  Text(
                                    product.description!,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '₹${(_customPrices[product.name] ?? product.suggestedPrice).toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: _customPrices.containsKey(product.name) 
                                                  ? Colors.blue 
                                                  : Colors.green,
                                            ),
                                          ),
                                          Text(
                                            'per ${product.unit}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () => _showPriceEditDialog(product),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            size: 16,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_customPrices.containsKey(product.name))
                                    Text(
                                      'Custom Price',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedProducts.remove(product.name);
                                } else {
                                  _selectedProducts.add(product.name);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // Bottom Action Bar
      bottomNavigationBar: _selectedProducts.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_selectedProducts.length} products selected',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Default stock: 10 units each',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Consumer<ShopProvider>(
                    builder: (context, shopProvider, _) {
                      return ElevatedButton.icon(
                        onPressed: shopProvider.isLoading ? null : _addSelectedProducts,
                        icon: shopProvider.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add_shopping_cart),
                        label: const Text('Add to Shop'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class _PriceEditDialog extends StatefulWidget {
  final PredefinedProduct product;
  final double initialPrice;

  const _PriceEditDialog({
    required this.product,
    required this.initialPrice,
  });

  @override
  State<_PriceEditDialog> createState() => _PriceEditDialogState();
}

class _PriceEditDialogState extends State<_PriceEditDialog> {
  late final TextEditingController _priceController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.initialPrice.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      setState(() {
        _errorText = 'Please enter a valid price';
      });
      return;
    }
    Navigator.of(context).pop(price);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Price',
        style: const TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Suggested: ₹${widget.product.suggestedPrice.toStringAsFixed(2)} per ${widget.product.unit}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Your Price (₹)',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _errorText,
                helperText: 'Price per ${widget.product.unit}',
              ),
              autofocus: true,
              onChanged: (value) {
                if (_errorText != null) {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
              onSubmitted: (_) => _validateAndSave(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _validateAndSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
