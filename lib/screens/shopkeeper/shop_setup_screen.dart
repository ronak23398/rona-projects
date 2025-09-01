import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../models/shop.dart';
import '../../providers/auth_provider.dart';
import '../../providers/shop_provider.dart';

class ShopSetupScreen extends StatefulWidget {
  final Shop? existingShop;
  
  const ShopSetupScreen({super.key, this.existingShop});

  @override
  State<ShopSetupScreen> createState() => _ShopSetupScreenState();
}

class _ShopSetupScreenState extends State<ShopSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _radiusController = TextEditingController();
  
  bool _openStatus = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingShop != null;
    
    if (_isEditing) {
      _nameController.text = widget.existingShop!.name;
      _addressController.text = widget.existingShop!.address;
      _pincodeController.text = widget.existingShop!.pincode;
      _radiusController.text = (widget.existingShop!.radiusKm ?? 5).toString();
      _openStatus = widget.existingShop!.openStatus;
    } else {
      _radiusController.text = '5'; // Default radius
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveShop() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final shopProvider = context.read<ShopProvider>();
    
    if (authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final shop = Shop(
      id: _isEditing ? widget.existingShop!.id : '',
      ownerId: authProvider.currentUser!.id,
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      pincode: _pincodeController.text.trim(),
      radiusKm: int.tryParse(_radiusController.text) ?? 5,
      openStatus: _openStatus,
      createdAt: _isEditing ? widget.existingShop!.createdAt : DateTime.now(),
    );

    bool success;
    if (_isEditing) {
      success = await shopProvider.updateShop(shop);
    } else {
      success = await shopProvider.createShop(shop);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Shop updated successfully!' : 'Shop created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(shopProvider.error ?? 'Failed to save shop'),
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
        title: Text(_isEditing ? 'Edit Shop' : 'Setup Your Shop'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
                  Icons.store,
                  size: 60,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  _isEditing ? 'Update Shop Details' : 'Create Your Shop',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in your shop information to start selling',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Shop Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    prefixIcon: const Icon(Icons.store),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Shop Address
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Shop Address',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your shop address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Pincode
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    prefixIcon: const Icon(Icons.pin_drop),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter pincode';
                    }
                    if (value.length != 6) {
                      return 'Pincode must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Delivery Radius
                TextFormField(
                  controller: _radiusController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Delivery Radius (km)',
                    prefixIcon: const Icon(Icons.delivery_dining),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: 'How far you can deliver (default: 5 km)',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter delivery radius';
                    }
                    final radius = int.tryParse(value);
                    if (radius == null || radius < 1 || radius > 50) {
                      return 'Radius must be between 1-50 km';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Shop Status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shop Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _openStatus ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: _openStatus ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _openStatus,
                            onChanged: (value) {
                              setState(() {
                                _openStatus = value;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save Button
                Consumer<ShopProvider>(
                  builder: (context, shopProvider, _) {
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: shopProvider.isLoading ? null : _handleSaveShop,
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
                                _isEditing ? 'Update Shop' : 'Create Shop',
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
}
