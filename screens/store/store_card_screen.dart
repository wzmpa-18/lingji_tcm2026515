import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../services/content_compliance.dart';
import '../../services/ad_service.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<StoreCategory> categories = [
    StoreCategory(
      id: '1',
      name: '吉祥物',
      icon: Icons.spa,
      color: Colors.red,
    ),
    StoreCategory(
      id: '2',
      name: '文创法器',
      icon: Icons.brush,
      color: Colors.brown,
    ),
    StoreCategory(
      id: '3',
      name: '正版书籍',
      icon: Icons.menu_book,
      color: Colors.blue,
    ),
    StoreCategory(
      id: '4',
      name: '学员笔记',
      icon: Icons.note,
      color: Colors.green,
    ),
  ];

  final List<StoreProduct> products = [
    StoreProduct(
      id: '1',
      name: '黄铜五帝钱挂饰',
      description: '传统黄铜五帝钱，工艺精湛，做工考究',
      price: 99,
      originalPrice: 159,
      imageUrl: '',
      category: '吉祥物',
      salesCount: 1280,
      rating: 4.8,
      isSelfOperated: true,
      disclaimer: '本產品僅作為傳統文化工藝品銷售，不涉及任何風水、改運等封建迷信內容。',
    ),
    StoreProduct(
      id: '2',
      name: '篆書毛筆套裝',
      description: '書法愛好者必備，包含狼毫、羊毫、兼毫三支',
      price: 158,
      originalPrice: 198,
      imageUrl: '',
      category: '文创法器',
      salesCount: 580,
      rating: 4.9,
      isSelfOperated: true,
      disclaimer: '本產品僅作文房四寶銷售，不涉及任何風水、改運等封建迷信內容。',
    ),
    StoreProduct(
      id: '3',
      name: '《傷寒論》註解版',
      description: '歷代名醫註解，含原文白話翻譯',
      price: 68,
      originalPrice: 98,
      imageUrl: '',
      category: '正版书籍',
      salesCount: 3200,
      rating: 4.9,
      isSelfOperated: true,
      disclaimer: '本書籍僅供中醫文化學習、研究使用，不構成醫療建議。',
    ),
    StoreProduct(
      id: '4',
      name: '針灸經絡學習筆記',
      description: '學員整理，含361個穴位詳解',
      price: 29,
      originalPrice: 49,
      imageUrl: '',
      category: '学员笔记',
      salesCount: 1600,
      rating: 4.7,
      isSelfOperated: false,
      instructorName: '李同学',
      disclaimer: '本筆記僅供學習參考，非官方教材，不構成醫療建議。',
    ),
    StoreProduct(
      id: '5',
      name: '《道德經》帛書版',
      description: '馬王堆帛書版，附名家註解',
      price: 45,
      originalPrice: 68,
      imageUrl: '',
      category: '正版书籍',
      salesCount: 2100,
      rating: 4.8,
      isSelfOperated: true,
      disclaimer: '本書籍僅供哲學、文化研究使用。',
    ),
    StoreProduct(
      id: '6',
      name: '銅錢八卦擺件',
      description: '仿古工藝，精美包裝',
      price: 128,
      originalPrice: 168,
      imageUrl: '',
      category: '吉祥物',
      salesCount: 860,
      rating: 4.6,
      isSelfOperated: true,
      disclaimer: '本產品僅作為傳統文化工藝品銷售，不涉及任何風水、改運等封建迷信內容。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final adService = AdService();
    final showAd = !adService.shouldHideAds(user?.memberLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商城'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.go('/store/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildComplianceBanner(),
                  const SizedBox(height: 16),
                  _buildCategories(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('平台自营'),
                  const SizedBox(height: 12),
                  _buildProductGrid(products.where((p) => p.isSelfOperated).toList()),
                  const SizedBox(height: 24),
                  _buildSectionTitle('学员专区'),
                  const SizedBox(height: 12),
                  _buildProductGrid(products.where((p) => !p.isSelfOperated).toList()),
                ],
              ),
            ),
          ),
          if (showAd) AdBannerWidget(memberLevel: user?.memberLevel),
        ],
      ),
    );
  }

  Widget _buildComplianceBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                '商城聲明',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '本商城所有商品僅作為傳統文化、藝術品、學習資料銷售，不誇大功效，不涉及任何治病、改運、風水等封建迷信或違規內容。',
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildProductGrid(List<StoreProduct> productList) {
    if (productList.isEmpty) {
      return const Center(child: Text('暂无商品'));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.72,
      children: productList.map((product) {
        return _buildProductCard(product);
      }).toList(),
    );
  }

  Widget _buildProductCard(StoreProduct product) {
    return GestureDetector(
      onTap: () => _showProductDetail(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 48, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.isSelfOperated)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '自营',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  if (!product.isSelfOperated)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.instructorName ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              '¥${product.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            if (product.originalPrice > product.price)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  '¥${product.originalPrice}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${product.salesCount}+',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetail(BuildContext context, StoreProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (product.isSelfOperated)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '自营',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red.shade600,
                                      ),
                                    ),
                                  ),
                                if (!product.isSelfOperated)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      product.instructorName ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  product.category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.orange, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${product.salesCount}人付款',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '¥',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${product.price}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (product.originalPrice > product.price)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      '¥${product.originalPrice}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '商品详情',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    product.description,
                                    style: const TextStyle(fontSize: 14, height: 1.6),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '重要声明',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.disclaimer,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.brown,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('加入购物车'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('立即购买'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  StoreCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class StoreProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final int salesCount;
  final double rating;
  final bool isSelfOperated;
  final String? instructorName;
  final String disclaimer;

  StoreProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.salesCount,
    required this.rating,
    required this.isSelfOperated,
    required this.disclaimer,
    this.instructorName,
  });
}
