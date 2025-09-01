class PredefinedProduct {
  final String name;
  final String category;
  final double suggestedPrice;
  final String unit;
  final String? imageUrl;
  final String? description;

  PredefinedProduct({
    required this.name,
    required this.category,
    required this.suggestedPrice,
    required this.unit,
    this.imageUrl,
    this.description,
  });
}

class ProductCatalog {
  static final List<PredefinedProduct> products = [
    // Groceries
    PredefinedProduct(
      name: 'Basmati Rice',
      category: 'Groceries',
      suggestedPrice: 120.0,
      unit: 'kg',
      description: 'Premium quality basmati rice',
    ),
    PredefinedProduct(
      name: 'Wheat Flour',
      category: 'Groceries',
      suggestedPrice: 45.0,
      unit: 'kg',
      description: 'Fresh wheat flour',
    ),
    PredefinedProduct(
      name: 'Sugar',
      category: 'Groceries',
      suggestedPrice: 42.0,
      unit: 'kg',
      description: 'White sugar',
    ),
    PredefinedProduct(
      name: 'Salt',
      category: 'Groceries',
      suggestedPrice: 20.0,
      unit: 'kg',
      description: 'Iodized salt',
    ),
    PredefinedProduct(
      name: 'Cooking Oil',
      category: 'Groceries',
      suggestedPrice: 180.0,
      unit: 'liter',
      description: 'Refined cooking oil',
    ),
    PredefinedProduct(
      name: 'Turmeric Powder',
      category: 'Groceries',
      suggestedPrice: 80.0,
      unit: 'unit',
      description: 'Pure turmeric powder (100g)',
    ),
    PredefinedProduct(
      name: 'Red Chili Powder',
      category: 'Groceries',
      suggestedPrice: 120.0,
      unit: 'unit',
      description: 'Spicy red chili powder (100g)',
    ),
    PredefinedProduct(
      name: 'Cumin Seeds',
      category: 'Groceries',
      suggestedPrice: 400.0,
      unit: 'kg',
      description: 'Whole cumin seeds',
    ),

    // Vegetables
    PredefinedProduct(
      name: 'Onions',
      category: 'Vegetables',
      suggestedPrice: 30.0,
      unit: 'kg',
      description: 'Fresh red onions',
    ),
    PredefinedProduct(
      name: 'Potatoes',
      category: 'Vegetables',
      suggestedPrice: 25.0,
      unit: 'kg',
      description: 'Fresh potatoes',
    ),
    PredefinedProduct(
      name: 'Tomatoes',
      category: 'Vegetables',
      suggestedPrice: 40.0,
      unit: 'kg',
      description: 'Fresh red tomatoes',
    ),
    PredefinedProduct(
      name: 'Green Chilies',
      category: 'Vegetables',
      suggestedPrice: 60.0,
      unit: 'kg',
      description: 'Fresh green chilies',
    ),
    PredefinedProduct(
      name: 'Ginger',
      category: 'Vegetables',
      suggestedPrice: 80.0,
      unit: 'kg',
      description: 'Fresh ginger',
    ),
    PredefinedProduct(
      name: 'Garlic',
      category: 'Vegetables',
      suggestedPrice: 200.0,
      unit: 'kg',
      description: 'Fresh garlic',
    ),
    PredefinedProduct(
      name: 'Carrots',
      category: 'Vegetables',
      suggestedPrice: 50.0,
      unit: 'kg',
      description: 'Fresh carrots',
    ),
    PredefinedProduct(
      name: 'Cauliflower',
      category: 'Vegetables',
      suggestedPrice: 35.0,
      unit: 'kg',
      description: 'Fresh cauliflower',
    ),
    PredefinedProduct(
      name: 'Cabbage',
      category: 'Vegetables',
      suggestedPrice: 25.0,
      unit: 'kg',
      description: 'Fresh cabbage',
    ),

    // Fruits
    PredefinedProduct(
      name: 'Bananas',
      category: 'Fruits',
      suggestedPrice: 50.0,
      unit: 'kg',
      description: 'Fresh ripe bananas',
    ),
    PredefinedProduct(
      name: 'Apples',
      category: 'Fruits',
      suggestedPrice: 150.0,
      unit: 'kg',
      description: 'Fresh red apples',
    ),
    PredefinedProduct(
      name: 'Oranges',
      category: 'Fruits',
      suggestedPrice: 80.0,
      unit: 'kg',
      description: 'Fresh oranges',
    ),
    PredefinedProduct(
      name: 'Mangoes',
      category: 'Fruits',
      suggestedPrice: 120.0,
      unit: 'kg',
      description: 'Sweet mangoes',
    ),
    PredefinedProduct(
      name: 'Grapes',
      category: 'Fruits',
      suggestedPrice: 100.0,
      unit: 'kg',
      description: 'Fresh grapes',
    ),

    // Dairy
    PredefinedProduct(
      name: 'Milk',
      category: 'Dairy',
      suggestedPrice: 55.0,
      unit: 'liter',
      description: 'Fresh cow milk',
    ),
    PredefinedProduct(
      name: 'Yogurt',
      category: 'Dairy',
      suggestedPrice: 60.0,
      unit: 'unit',
      description: 'Fresh yogurt (500g)',
    ),
    PredefinedProduct(
      name: 'Paneer',
      category: 'Dairy',
      suggestedPrice: 300.0,
      unit: 'kg',
      description: 'Fresh paneer',
    ),
    PredefinedProduct(
      name: 'Butter',
      category: 'Dairy',
      suggestedPrice: 450.0,
      unit: 'kg',
      description: 'Fresh butter',
    ),
    PredefinedProduct(
      name: 'Cheese',
      category: 'Dairy',
      suggestedPrice: 400.0,
      unit: 'kg',
      description: 'Processed cheese',
    ),

    // Bakery
    PredefinedProduct(
      name: 'White Bread',
      category: 'Bakery',
      suggestedPrice: 25.0,
      unit: 'unit',
      description: 'Fresh white bread (loaf)',
    ),
    PredefinedProduct(
      name: 'Brown Bread',
      category: 'Bakery',
      suggestedPrice: 35.0,
      unit: 'unit',
      description: 'Whole wheat bread (loaf)',
    ),
    PredefinedProduct(
      name: 'Biscuits',
      category: 'Bakery',
      suggestedPrice: 20.0,
      unit: 'unit',
      description: 'Assorted biscuits (packet)',
    ),
    PredefinedProduct(
      name: 'Cake',
      category: 'Bakery',
      suggestedPrice: 300.0,
      unit: 'unit',
      description: 'Fresh cake (piece)',
    ),

    // Snacks
    PredefinedProduct(
      name: 'Chips',
      category: 'Snacks',
      suggestedPrice: 20.0,
      unit: 'unit',
      description: 'Potato chips (packet)',
    ),
    PredefinedProduct(
      name: 'Namkeen',
      category: 'Snacks',
      suggestedPrice: 150.0,
      unit: 'kg',
      description: 'Mixed namkeen',
    ),
    PredefinedProduct(
      name: 'Nuts',
      category: 'Snacks',
      suggestedPrice: 600.0,
      unit: 'kg',
      description: 'Mixed dry fruits',
    ),

    // Beverages
    PredefinedProduct(
      name: 'Tea',
      category: 'Beverages',
      suggestedPrice: 400.0,
      unit: 'kg',
      description: 'Black tea leaves',
    ),
    PredefinedProduct(
      name: 'Coffee',
      category: 'Beverages',
      suggestedPrice: 800.0,
      unit: 'kg',
      description: 'Ground coffee',
    ),
    PredefinedProduct(
      name: 'Soft Drinks',
      category: 'Beverages',
      suggestedPrice: 40.0,
      unit: 'unit',
      description: 'Carbonated drinks (bottle)',
    ),
    PredefinedProduct(
      name: 'Fruit Juice',
      category: 'Beverages',
      suggestedPrice: 80.0,
      unit: 'liter',
      description: 'Fresh fruit juice',
    ),

    // Personal Care
    PredefinedProduct(
      name: 'Soap',
      category: 'Personal Care',
      suggestedPrice: 30.0,
      unit: 'unit',
      description: 'Bathing soap (piece)',
    ),
    PredefinedProduct(
      name: 'Shampoo',
      category: 'Personal Care',
      suggestedPrice: 150.0,
      unit: 'unit',
      description: 'Hair shampoo (bottle)',
    ),
    PredefinedProduct(
      name: 'Toothpaste',
      category: 'Personal Care',
      suggestedPrice: 80.0,
      unit: 'unit',
      description: 'Dental care toothpaste (tube)',
    ),
    PredefinedProduct(
      name: 'Toothbrush',
      category: 'Personal Care',
      suggestedPrice: 25.0,
      unit: 'unit',
      description: 'Soft bristle toothbrush (piece)',
    ),

    // Household
    PredefinedProduct(
      name: 'Detergent Powder',
      category: 'Household',
      suggestedPrice: 200.0,
      unit: 'kg',
      description: 'Washing powder',
    ),
    PredefinedProduct(
      name: 'Dish Soap',
      category: 'Household',
      suggestedPrice: 80.0,
      unit: 'unit',
      description: 'Dishwashing liquid (bottle)',
    ),
    PredefinedProduct(
      name: 'Toilet Paper',
      category: 'Household',
      suggestedPrice: 120.0,
      unit: 'unit',
      description: 'Soft toilet paper (pack)',
    ),
    PredefinedProduct(
      name: 'Cleaning Cloth',
      category: 'Household',
      suggestedPrice: 50.0,
      unit: 'unit',
      description: 'Microfiber cleaning cloth (pack)',
    ),
  ];

  static List<String> get categories {
    return products.map((p) => p.category).toSet().toList()..sort();
  }

  static List<PredefinedProduct> getProductsByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  static List<PredefinedProduct> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return products.where((p) => 
      p.name.toLowerCase().contains(lowercaseQuery) ||
      p.category.toLowerCase().contains(lowercaseQuery) ||
      (p.description?.toLowerCase().contains(lowercaseQuery) ?? false)
    ).toList();
  }
}
