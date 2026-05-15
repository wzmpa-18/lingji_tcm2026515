import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class LingjiProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<LingjiTransaction> _transactions = [];
  List<LingjiTransaction> _openOrders = [];
  double _currentPrice = 0.1;
  PaymentMethod? _wechatPayment;
  PaymentMethod? _alipayPayment;

  List<LingjiTransaction> get transactions => _transactions;
  List<LingjiTransaction> get openOrders => _openOrders;
  double get currentPrice => _currentPrice;
  PaymentMethod? get wechatPayment => _wechatPayment;
  PaymentMethod? get alipayPayment => _alipayPayment;

  Future<void> loadTransactions(String userId) async {
    _transactions = await _dbService.getTransactions(userId: userId);
    notifyListeners();
  }

  Future<void> loadOpenOrders() async {
    _openOrders = await _dbService.getOpenOrders();
    notifyListeners();
  }

  void setCurrentPrice(double price) {
    _currentPrice = price;
    notifyListeners();
  }

  Future<void> createSellOrder({
    required String sellerId,
    required int amount,
    required double price,
  }) async {
    final transaction = LingjiTransaction(
      id: const Uuid().v4(),
      sellerId: sellerId,
      amount: amount,
      price: price,
      totalAmount: amount * price / 10,
      status: 'open',
      createdAt: DateTime.now(),
    );
    await _dbService.insertTransaction(transaction);
    _openOrders.add(transaction);
    notifyListeners();
  }

  Future<void> buyOrder({
    required LingjiTransaction order,
    required String buyerId,
  }) async {
    final updated = order.copyWith(
      buyerId: buyerId,
      status: 'paid',
    );
    await _dbService.updateTransaction(updated);
    _openOrders.removeWhere((t) => t.id == order.id);
    _transactions.insert(0, updated);
    notifyListeners();
  }

  Future<void> confirmPayment(String transactionId) async {
    final tx = _transactions.firstWhere((t) => t.id == transactionId);
    final updated = tx.copyWith(status: 'completed', completedAt: DateTime.now());
    await _dbService.updateTransaction(updated);
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index >= 0) _transactions[index] = updated;
    notifyListeners();
  }

  Future<void> disputeTransaction(String transactionId) async {
    final tx = _transactions.firstWhere((t) => t.id == transactionId);
    final updated = tx.copyWith(status: 'disputed');
    await _dbService.updateTransaction(updated);
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index >= 0) _transactions[index] = updated;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    if (method.type == 'wechat') {
      _wechatPayment = method;
    } else if (method.type == 'alipay') {
      _alipayPayment = method;
    }
    notifyListeners();
  }
}
