import 'package:flutter/material.dart';

class NewbieGuideScreen extends StatelessWidget {
  const NewbieGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新手必读'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: '平台规则',
            icon: Icons.rule,
            children: [
              _buildListItem('双积分体系说明：灵积用于交易变现，学海积分仅用于学习', Icons.info),
              _buildListItem('有效学习才计时，挂机超过5分钟自动暂停', Icons.timer),
              _buildListItem('每天学习上限2小时，可获得16学海积分', Icons.limit),
              _buildListItem('会员扣费：从灵积余额中扣除', Icons.money),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '会员权益',
            icon: Icons.verified_user,
            children: [
              _buildListItem('初级会员：解锁基础功能，享有云备份', Icons.star_border),
              _buildListItem('高级会员：解锁高级功能，手续费优惠', Icons.star),
              _buildListItem('专业会员：尊享全部功能，三级分润，推广奖励', Icons.star_half),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '三级奖励',
            icon: Icons.group,
            children: [
              _buildListItem('一级奖励：直接推荐会员，享受20%分润', Icons.person_add),
              _buildListItem('二级奖励：间接推荐，享受10%分润', Icons.people),
              _buildListItem('三级奖励：无奖励，防止多层级', Icons.remove_circle_outline),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '积分用途',
            icon: Icons.card_giftcard,
            children: [
              _buildListItem('灵积：可交易变现、购买商品、抵扣会员费', Icons.monetization_on),
              _buildListItem('学海积分：兑换小礼物、专属标识、公开课解锁', Icons.book),
              _buildListItem('学海积分不能交易变现，只能用于学习相关', Icons.lock),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '手续费标准',
            icon: Icons.receipt,
            children: [
              _buildListItem('C2C交易手续费：2%，最低10灵积，最高100灵积', Icons.percent),
              _buildListItem('初级会员：无手续费优惠', Icons.star_border),
              _buildListItem('高级会员：手续费减半', Icons.star),
              _buildListItem('专业会员：手续费全免', Icons.star_half),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '学习积分机制',
            icon: Icons.school,
            children: [
              _buildListItem('有效学习累计60分钟=1小时', Icons.timer),
              _buildListItem('每小时奖励8学海积分', Icons.emoji_events),
              _buildListItem('碎片化学习也可以累计', Icons.access_time),
              _buildListItem('每天自动结算奖励', Icons.refresh),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: '境内境外支付差异',
            icon: Icons.payment,
            children: [
              _buildListItem('境内用户：支持微信支付、支付宝', Icons.payments),
              _buildListItem('境外用户：支持加密货币支付', Icons.currency_bitcoin),
              _buildListItem('所有用户：都可以使用灵积抵扣', Icons.diamond),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
