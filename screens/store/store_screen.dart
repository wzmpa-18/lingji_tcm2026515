import 'package:flutter/material.dart';
import '../../models/store.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  ProductCategory _selectedCategory = ProductCategory.book;

  final List<StoreProduct> _demoProducts = [
    StoreProduct(
      id: '1',
      title: '黄帝内经（精装版）',
      description: '经典中医典籍，详细注解版',
      images: ['https://via.placeholder.com/300x400'],
      category: ProductCategory.book,
      price: 299,
      originalPrice: 399,
      stock: 100,
      sales: 500,
      isLingjiAvailable: true,
      lingjiPrice: 150,
      isHot: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    StoreProduct(
      id: '2',
      title: '道教神像摆件',
      description: '精美雕刻，祈福保平安',
      images: ['https://via.placeholder.com/300x400'],
      category: ProductCategory.mascot,
      price: 199,
      stock: 50,
      sales: 200,
      isLingjiAvailable: true,
      lingjiPrice: 100,
      isNew: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    StoreProduct(
      id: '3',
      title: '中医养生茶包',
      description: '精选中药材，科学配比',
      images: ['https://via.placeholder.com/300x400'],
      category: ProductCategory.health,
      price: 99,
      originalPrice: 129,
      stock: 200,
      sales: 1000,
      isLingjiAvailable: true,
      lingjiPrice: 50,
      isHot: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    StoreProduct(
      id: '4',
      title: '文房四宝套装',
      description: '优质笔墨纸砚，书法爱好者必备',
      images: ['https://via.placeholder.com/300x400'],
      category: ProductCategory.stationery,
      price: 499,
      stock: 30,
      sales: 150,
      isLingjiAvailable: true,
      lingjiPrice: 250,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商城'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ProductCategory.values.length,
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                '${category.icon} ${category.displayName}',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue,
              checkmarkColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final filteredProducts = _demoProducts.where((p) => p.category == _selectedCategory).toList();
    if (filteredProducts.isEmpty) {
      filteredProducts.addAll(_demoProducts);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(filteredProducts[index]);
      },
    );
  }

  Widget _buildProductCard(StoreProduct product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                if (product.isHot)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '热销',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (product.isNew)
                  Positioned(
                    top: 8,
                    left: product.isHot ? 60 : 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '新品',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '¥${product.price}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (product.originalPrice > product.price)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '¥${product.originalPrice}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                if (product.isLingjiAvailable)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.diamond, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${product.lingjiPrice}灵积',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('立即购买'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
