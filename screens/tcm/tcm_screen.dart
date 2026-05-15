import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tcm_provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../services/content_compliance.dart';
import '../../models/pediatric/pediatric_model.dart';

class TcmScreen extends StatefulWidget {
  const TcmScreen({super.key});

  @override
  State<TcmScreen> createState() => _TcmScreenState();
}

class _TcmScreenState extends State<TcmScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        title: const Text('中医经方研习'),
        actions: [
          IconButton(
            icon: const Icon(Icons.child_care),
            tooltip: '倪海厦四件套',
            onPressed: () => _showNiHaixiaSuite(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '经方', icon: Icon(Icons.medical_services_outlined)),
            Tab(text: '儿科', icon: Icon(Icons.child_care)),
            Tab(text: '舌脉', icon: Icon(Icons.visibility_outlined)),
            Tab(text: '董氏', icon: Icon(Icons.spa)),
            Tab(text: '正骨', icon: Icon(Icons.accessibility_new)),
            Tab(text: '古籍', icon: Icon(Icons.menu_book)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PrescriptionTab(),
                _PediatricTab(),
                _TonguePulseTab(),
                _DongAcupointTab(),
                _BoneSettingTab(),
                _AncientBooksTab(),
              ],
            ),
          ),
          ComplianceHelper.buildDisclaimerBanner(),
        ],
      ),
    );
  }

  void _showNiHaixiaSuite(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => _NiHaixiaSuiteSheet(
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _NiHaixiaSuiteSheet extends StatelessWidget {
  final ScrollController scrollController;

  const _NiHaixiaSuiteSheet({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '倪海厦四件套',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '天纪 | 人纪 | 地纪 | 案例',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '永久免费',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _buildNiHaixiaCard(
                  context,
                  '天纪',
                  '天文地理风水地理全套',
                  Icons.public,
                  Colors.blue,
                  () {},
                ),
                _buildNiHaixiaCard(
                  context,
                  '人纪',
                  '中医针灸伤寒金匮全套',
                  Icons.accessibility_new,
                  Colors.red,
                  () {},
                ),
                _buildNiHaixiaCard(
                  context,
                  '地纪',
                  '地理风水命理全套',
                  Icons.landscape,
                  Colors.green,
                  () {},
                ),
                _buildNiHaixiaCard(
                  context,
                  '医案',
                  '临床医案详解',
                  Icons.medical_services,
                  Colors.purple,
                  () {},
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            '学习说明',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '本板块整理倪海厦老师全部学术资料，包含天纪、人纪、地纪及临床医案，用于针灸文化学习与技法研究，非实操指导。',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ContentCompliance.pageDisclaimer,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNiHaixiaCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrescriptionTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TcmProvider>(
      builder: (context, provider, _) {
        final prescriptions = provider.prescriptions;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medication, color: AppTheme.primaryColor),
                ),
                title: Text(prescription.name),
                subtitle: Text(
                  prescription.syndrome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showPrescriptionDetail(context, prescription);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showPrescriptionDetail(BuildContext context, dynamic prescription) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
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
              Text(
                prescription.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '经方配伍思路研习',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSection('经典配伍', prescription.herbs?.join(' · ') ?? '暂无'),
              _buildSection('症候分析', prescription.syndrome),
              _buildSection('功效主治', prescription.effect),
              _buildSection('用法用量', prescription.usage ?? '暂无'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  ContentCompliance.pageDisclaimer,
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _PediatricTab extends StatelessWidget {
  final List<PediatricTechnique> _techniques = PediatricTechnique.allTechniques;
  final List<PediatricCondition> _conditions = PediatricCondition.commonConditions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(),
          const SizedBox(height: 20),
          const Text(
            '小儿推拿技法',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._techniques.map((tech) => _buildTechniqueCard(context, tech)),
          const SizedBox(height: 20),
          const Text(
            '常见症候调理',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._conditions.map((condition) => _buildConditionCard(context, condition)),
          const SizedBox(height: 20),
          _buildNiHaixiaReference(),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.child_care, color: Colors.pink.shade700),
              const SizedBox(width: 8),
              Text(
                '儿科调理学习',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.pink.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '整理倪海厦小儿论述、小儿辨证、小儿调理手法，包含开天河水等经典小儿推拿实操内容，供学习研究使用。',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard(BuildContext context, PediatricTechnique tech) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTechniqueDetail(context, tech),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.touch_app, color: Colors.pink.shade700, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tech.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildConditionCard(BuildContext context, PediatricCondition condition) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.green.shade50,
      child: InkWell(
        onTap: () => _showConditionDetail(context, condition),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.healing, color: Colors.green.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      condition.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      condition.symptoms.join('、'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNiHaixiaReference() {
    return Container(
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '倪海厦参考',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '「小儿为纯阳之体，脏腑轻灵，随拨随应」\n—— 倪海厦',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showTechniqueDetail(BuildContext context, PediatricTechnique tech) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tech.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('功效', tech.effect),
              _buildDetailRow('位置', tech.location),
              _buildDetailRow('操作', tech.technique),
              _buildDetailRow('注意事项', tech.precautions),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showConditionDetail(BuildContext context, PediatricCondition condition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(condition.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('症状', condition.symptoms.join('、')),
              _buildDetailRow('辨证', condition.diagnosis),
              _buildDetailRow('调理方案', condition.treatmentPlan),
              _buildDetailRow('倪师提示', condition.nihaixiaNote),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _TonguePulseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCard(
          '舌诊学习',
          '舌质、舌苔、舌色辨证',
          Icons.visibility,
          Colors.blue,
          () {},
        ),
        _buildCard(
          '脉诊学习',
          '浮沉迟数、二十八脉',
          Icons.favorite,
          Colors.red,
          () {},
        ),
        _buildCard(
          '面诊学习',
          '面部色诊、望诊基础',
          Icons.face,
          Colors.green,
          () {},
        ),
      ],
    );
  }

  Widget _buildCard(String title, String desc, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(desc),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _DongAcupointTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.spa, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('董氏奇穴', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('完整收录董氏奇穴体系', style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('查看穴位'),
          ),
        ],
      ),
    );
  }
}

class _BoneSettingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.accessibility_new, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('正骨推拿', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('传统正骨技法学习', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _AncientBooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBookCard('伤寒论', '张仲景', '中医临床奠基之作'),
        _buildBookCard('金匮要略', '张仲景', '杂病论治典范'),
        _buildBookCard('黄帝内经', '黄帝', '中医理论渊薮'),
        _buildBookCard('难经', '扁鹊', '中医基础理论'),
        _buildBookCard('神农本草经', '神农', '中药学奠基之作'),
        _buildBookCard('温病条辨', '吴鞠通', '温病学代表著作'),
      ],
    );
  }

  Widget _buildBookCard(String title, String author, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.menu_book, color: AppTheme.primaryColor),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('作者：$author'),
            Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}
