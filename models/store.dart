class StoreProduct {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final ProductCategory category;
  final int price;
  final int originalPrice;
  final int stock;
  final int sales;
  final bool isLingjiAvailable;
  final int lingjiPrice;
  final bool isXuehaiAvailable;
  final int xuehaiPrice;
  final bool isHot;
  final bool isNew;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.price,
    this.originalPrice = 0,
    required this.stock,
    this.sales = 0,
    this.isLingjiAvailable = true,
    this.lingjiPrice = 0,
    this.isXuehaiAvailable = false,
    this.xuehaiPrice = 0,
    this.isHot = false,
    this.isNew = false,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images.join(','),
      'category': category.name,
      'price': price,
      'original_price': originalPrice,
      'stock': stock,
      'sales': sales,
      'is_lingji_available': isLingjiAvailable ? 1 : 0,
      'lingji_price': lingjiPrice,
      'is_xuehai_available': isXuehaiAvailable ? 1 : 0,
      'xuehai_price': xuehaiPrice,
      'is_hot': isHot ? 1 : 0,
      'is_new': isNew ? 1 : 0,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory StoreProduct.fromMap(Map<String, dynamic> map) {
    return StoreProduct(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      images: (map['images'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      category: ProductCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ProductCategory.other,
      ),
      price: map['price'] ?? 0,
      originalPrice: map['original_price'] ?? 0,
      stock: map['stock'] ?? 0,
      sales: map['sales'] ?? 0,
      isLingjiAvailable: map['is_lingji_available'] == 1,
      lingjiPrice: map['lingji_price'] ?? 0,
      isXuehaiAvailable: map['is_xuehai_available'] == 1,
      xuehaiPrice: map['xuehai_price'] ?? 0,
      isHot: map['is_hot'] == 1,
      isNew: map['is_new'] == 1,
      sortOrder: map['sort_order'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

enum ProductCategory {
  book,
  stationery,
  mascot,
  health,
  virtual,
  other,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.book:
        return '书籍';
      case ProductCategory.stationery:
        return '文创';
      case ProductCategory.mascot:
        return '吉祥物';
      case ProductCategory.health:
        return '养生周边';
      case ProductCategory.virtual:
        return '虚拟商品';
      case ProductCategory.other:
        return '其他';
    }
  }

  String get icon {
    switch (this) {
      case ProductCategory.book:
        return '📚';
      case ProductCategory.stationery:
        return '✏️';
      case ProductCategory.mascot:
        return '🎁';
      case ProductCategory.health:
        return '🌿';
      case ProductCategory.virtual:
        return '💎';
      case ProductCategory.other:
        return '🛒';
    }
  }
}

class StoreOrder {
  final String id;
  final String userId;
  final String productId;
  final String productTitle;
  final String productImage;
  final int quantity;
  final int totalAmount;
  final PaymentMethod paymentMethod;
  final bool useLingji;
  final int lingjiUsed;
  final OrderStatus status;
  final String? shippingName;
  final String? shippingPhone;
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreOrder({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.quantity,
    required this.totalAmount,
    required this.paymentMethod,
    this.useLingji = false,
    this.lingjiUsed = 0,
    required this.status,
    this.shippingName,
    this.shippingPhone,
    this.shippingAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_title': productTitle,
      'product_image': productImage,
      'quantity': quantity,
      'total_amount': totalAmount,
      'payment_method': paymentMethod.name,
      'use_lingji': useLingji ? 1 : 0,
      'lingji_used': lingjiUsed,
      'status': status.name,
      'shipping_name': shippingName,
      'shipping_phone': shippingPhone,
      'shipping_address': shippingAddress,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory StoreOrder.fromMap(Map<String, dynamic> map) {
    return StoreOrder(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      productTitle: map['product_title'],
      productImage: map['product_image'] ?? '',
      quantity: map['quantity'] ?? 1,
      totalAmount: map['total_amount'] ?? 0,
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == map['payment_method'],
        orElse: () => PaymentMethod.wechat,
      ),
      useLingji: map['use_lingji'] == 1,
      lingjiUsed: map['lingji_used'] ?? 0,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      shippingName: map['shipping_name'],
      shippingPhone: map['shipping_phone'],
      shippingAddress: map['shipping_address'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}

enum OrderStatus {
  pending,
  paid,
  shipped,
  completed,
  cancelled,
  refunded,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return '待支付';
      case OrderStatus.paid:
        return '已支付';
      case OrderStatus.shipped:
        return '已发货';
      case OrderStatus.completed:
        return '已完成';
      case OrderStatus.cancelled:
        return '已取消';
      case OrderStatus.refunded:
        return '已退款';
    }
  }
}

enum PaymentMethod {
  wechat,
  alipay,
  crypto,
  lingji,
  xuehai,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.wechat:
        return '微信支付';
      case PaymentMethod.alipay:
        return '支付宝';
      case PaymentMethod.crypto:
        return '加密货币';
      case PaymentMethod.lingji:
        return '灵积';
      case PaymentMethod.xuehai:
        return '学海积分';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.wechat:
        return '💬';
      case PaymentMethod.alipay:
        return '💰';
      case PaymentMethod.crypto:
        return '₿';
      case PaymentMethod.lingji:
        return '💎';
      case PaymentMethod.xuehai:
        return '📖';
    }
  }
}
