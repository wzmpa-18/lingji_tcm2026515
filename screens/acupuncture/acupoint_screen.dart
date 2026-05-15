import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/acupuncture_provider.dart';
import '../../models/acupoint.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../services/watermark_service.dart';
import '../../services/referral_service.dart';
import '../../services/content_compliance.dart';
import '../../widgets/watermark_widget.dart';

class AcupointScreen extends StatefulWidget {
  const AcupointScreen({super.key});

  @override
  State<AcupointScreen> createState() => _AcupointScreenState();
}

class _AcupointScreenState extends State<AcupointScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _repaintKey = GlobalKey();
  final WatermarkService _watermarkService = WatermarkService();
  final ReferralService _referralService = ReferralService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 15, vsync: this);
    _referralService.generateReferralCode('user_${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('针灸经络学习'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showShareOptions(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索穴位名称、功效...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    context.read<AcupunctureProvider>().search(value);
                  },
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: AppConstants.meridians.map((m) => Tab(text: m)).toList(),
                onTap: (index) {
                  context.read<AcupunctureProvider>().setSelectedMeridian(
                    AppConstants.meridians[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: RepaintBoundary(
        key: _repaintKey,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: AppConstants.meridians.map((meridian) {
                      return _buildAcupointList(meridian);
                    }).toList(),
                  ),
                ),
                _buildDisclaimerBar(),
              ],
            ),
            _buildWatermark(),
            _buildQRCode(),
          ],
        ),
      ),
    );
  }

  Widget _buildWatermark() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Center(
        child: _watermarkService.buildWatermarkWidget(),
      ),
    );
  }

  Widget _buildQRCode() {
    if (!_referralService.showQRCode) {
      return const SizedBox.shrink();
    }
    return Positioned(
      right: 16,
      bottom: 60,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _referralService.buildReferralQRWidget(size: 50, showHint: false),
      ),
    );
  }

  Widget _buildDisclaimerBar() {
    return ComplianceHelper.buildDisclaimerBanner();
  }

  Widget _buildAcupointList(String meridian) {
    return Consumer<AcupunctureProvider>(
      builder: (context, provider, _) {
        final acupoints = provider.getAcupointsByMeridian(meridian);

        if (acupoints.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  '暂无$meridian穴位数据',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: acupoints.length,
          itemBuilder: (context, index) {
            return _buildAcupointCard(acupoints[index]);
          },
        );
      },
    );
  }

  Widget _buildAcupointCard(Acupoint acupoint) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showAcupointDetail(acupoint),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    acupoint.name.substring(0, acupoint.name.length > 2 ? 2 : acupoint.name.length),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          acupoint.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          acupoint.nameEn,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      acupoint.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      acupoint.indication,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showAcupointDetail(Acupoint acupoint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.accessibility_new,
                            size: 48,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                acupoint.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                acupoint.nameEn,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDetailSection('经络', acupoint.meridian),
                    _buildDetailSection('定位', acupoint.location),
                    _buildDetailSection('主治', acupoint.indication),
                    _buildDetailSection('技法', acupoint.technique),
                    const SizedBox(height: 20),
                    _buildStudyNote(),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _watermarkService.buildWatermarkWidget(),
              ),
              if (_referralService.showQRCode)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: _referralService.buildReferralQRWidget(size: 60, showHint: false),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              Text(
                '学习提示',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '本板块整理传统经络穴位、董氏奇穴、倪海厦针灸学术、丘雅昌配穴经验，用于针灸文化学习与技法研究，非实操施针指导。',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            ContentCompliance.pageDisclaimer,
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '分享设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('显示推广二维码'),
              subtitle: const Text('在分享内容中显示您的专属二维码'),
              value: _referralService.showQRCode,
              activeColor: const Color(0xFF8B4513),
              onChanged: (value) {
                setState(() {});
                _referralService.toggleShowQRCode(value);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('分享当前页面'),
              subtitle: Text('邀请码: ${_referralService.currentConfig?.referralCode ?? "暂无"}'),
              onTap: () {
                Navigator.pop(context);
                _doShare();
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('保存为图片'),
              onTap: () {
                Navigator.pop(context);
                _saveAsImage();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _doShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在生成分享内容...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _saveAsImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在保存图片...'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
