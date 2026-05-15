import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/registration_payment.dart';
import '../../services/c2c_service.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class LingjiMarketScreen extends StatefulWidget {
  const LingjiMarketScreen({super.key});

  @override
  State<LingjiMarketScreen> createState() => _LingjiMarketScreenState();
}

class _LingjiMarketScreenState extends State<LingjiMarketScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isBuyMode = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('积分市场'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '我要购买'),
            Tab(text: '我要出售'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBuyTab(),
          _buildSellTab(),
        ],
      ),
    );
  }

  Widget _buildBuyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarketInfo(),
          const SizedBox(height: 16),
          _buildOrderForm(true),
          const SizedBox(height: 24),
          _buildFeeCalculator(),
        ],
      ),
    );
  }

  Widget _buildSellTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSellerInfo(),
          const SizedBox(height: 16),
          _buildOrderForm(false),
          const SizedBox(height: 24),
          _buildFeeCalculator(),
        ],
      ),
    );
  }

  Widget _buildMarketInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade400, Colors.blue.shade600]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white),
              SizedBox(width: 8),
              Text('灵积市场', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMarketStat('当前价格', '0.10元', Colors.white),
              _buildMarketStat('24H交易量', '125,000', Colors.white),
              _buildMarketStat('挂单数量', '89笔', Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('固定汇率：10灵积 = 1元，永不增发，通缩保值', style: TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSellerInfo() {
    final user = context.read<UserProvider>().currentUser;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sell, color: Colors.white),
              SizedBox(width: 8),
              Text('出售灵积', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMarketStat('可出售', '${user?.lingjiBalance ?? 0}', Colors.white),
              _buildMarketStat('挂单中', '0', Colors.white),
              _buildMarketStat('已成交', '0', Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
            child: const Row(
              children: [
                Icon(Icons.security, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('平台托管灵积，收到付款自动放行，资金安全有保障', style: TextStyle(color: Colors.white, fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm(bool isBuy) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isBuy ? '购买订单' : '出售订单', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '购买数量（灵积）',
                hintText: '请输入购买数量',
                prefixIcon: const Icon(Icons.toll),
                suffixText: '积分',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: '单价（元/10积分）',
                hintText: '0.10',
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: '元',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('预计总价：'),
                  Text('¥ 0.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('支付方式', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildPaymentChip('💚 微信', PaymentType.wechat),
                _buildPaymentChip('🔵 支付宝', PaymentType.alipay),
                _buildPaymentChip('₿ USDT', PaymentType.crypto),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: isBuy ? Colors.blue : Colors.green),
                child: Text(isBuy ? '立即购买' : '立即出售'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentChip(String label, PaymentType type) {
    return ActionChip(
      avatar: Text(label.split(' ')[0]),
      label: Text(label.split(' ')[1]),
      onPressed: () {},
    );
  }

  Widget _buildFeeCalculator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calculate, color: Colors.orange),
                SizedBox(width: 8),
                Text('手续费计算器', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Text('按交易额2%收取，单笔最低10积分，最高100积分', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: '交易金额',
                      hintText: '输入金额',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        const Text('手续费', style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${C2CFeeService.calculateFee(1000)}积分', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildFeeRow('交易金额', '1000积分'),
            _buildFeeRow('标准费率', '2%'),
            _buildFeeRow('标准手续费', '20积分'),
            _buildFeeRow('分润-直推(20%)', '4积分'),
            _buildFeeRow('分润-二级(10%)', '2积分'),
            _buildFeeRow('平台收益', '14积分'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
