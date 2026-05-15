import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/acupuncture_service.dart';
import '../../models/acupuncture_class.dart';
import '../../config/theme.dart';

class EnhancedAcupunctureScreen extends StatefulWidget {
  const EnhancedAcupunctureScreen({super.key});

  @override
  State<EnhancedAcupunctureScreen> createState() => _EnhancedAcupunctureScreenState();
}

class _EnhancedAcupunctureScreenState extends State<EnhancedAcupunctureScreen> with SingleTickerProviderStateMixin {
  final AcupunctureService _acupunctureService = AcupunctureService();
  late TabController _tabController;
  String _selectedSchool = '倪海厦针灸';
  String _selectedLayer = '皮肤';
  String _selectedView = '正面';

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
        title: const Text('针灸学习'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '3D穴位'),
            Tab(text: '古籍流派'),
            Tab(text: '子午流注'),
            Tab(text: '骨度分寸'),
            Tab(text: 'AI配穴'),
            Tab(text: '新手入门'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _build3DAcupointTab(),
          _buildClassicsTab(),
          _buildZibufaluzhuTab(),
          _buildBoneMeasurementTab(),
          _buildAIZuoxueTab(),
          _buildBeginnerTab(),
        ],
      ),
    );
  }

  Widget _build3DAcupointTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSchoolSelector(),
          const SizedBox(height: 16),
          _buildBodyViewer(),
          const SizedBox(height: 16),
          _buildLayerSelector(),
          const SizedBox(height: 16),
          _buildViewSelector(),
          const SizedBox(height: 16),
          _buildMeridianSelector(),
        ],
      ),
    );
  }

  Widget _buildSchoolSelector() {
    final schools = _acupunctureService.getSchools();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.school, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '选择流派',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: schools.map((school) {
                final isSelected = _selectedSchool == school.name;
                return ChoiceChip(
                  label: Text(school.name),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedSchool = school.name);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyViewer() {
    return Card(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.accessibility_new, color: AppTheme.secondaryColor, size: 32),
                SizedBox(width: 8),
                Text(
                  '3D人体解剖模型',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(75),
                        border: Border.all(color: Colors.pink.shade200, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, size: 40, color: Colors.pink),
                          const SizedBox(height: 8),
                          Text(
                            _selectedView,
                            style: TextStyle(color: Colors.pink.shade300),
                          ),
                          Text(
                            _selectedLayer,
                            style: TextStyle(color: Colors.pink.shade300, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 30,
                      child: _buildAcupointMarker('百会', Colors.red),
                    ),
                    Positioned(
                      top: 100,
                      left: 20,
                      child: _buildAcupointMarker('合谷', Colors.blue),
                    ),
                    Positioned(
                      top: 150,
                      right: 30,
                      child: _buildAcupointMarker('足三里', Colors.green),
                    ),
                    Positioned(
                      bottom: 80,
                      left: 40,
                      child: _buildAcupointMarker('涌泉', Colors.orange),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('旋转：360度自由旋转查看')),
                    );
                  },
                  icon: const Icon(Icons.rotate_right),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('缩放：双指缩放查看细节')),
                    );
                  },
                  icon: const Icon(Icons.zoom_in),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('分层：切换皮肤/肌肉/骨骼视图')),
                    );
                  },
                  icon: const Icon(Icons.layers),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcupointMarker(String name, Color color) {
    return GestureDetector(
      onTap: () {
        _showAcupointInfo(name);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showAcupointInfo(String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
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
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.spa, color: AppTheme.primaryColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            '$_selectedSchool定位',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoRow('定位', '根据$_selectedSchool理论定位'),
                _buildInfoRow('主治', '头痛、眩晕、失眠'),
                _buildInfoRow('针法', '平刺0.5-1寸'),
                _buildInfoRow('灸法', '艾灸5-10分钟'),
                _buildInfoRow('禁灸', '无特殊禁忌'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '倪海厦取穴要点',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(_acupunctureService.getMnemonic(name)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildLayerSelector() {
    final layers = _acupunctureService.getBodyLayers();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.layers, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '分层解剖',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: layers.map((layer) {
                final isSelected = _selectedLayer == layer;
                return ChoiceChip(
                  label: Text(layer),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedLayer = layer);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewSelector() {
    final views = _acupunctureService.getRotationViews();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.rotate_90_degrees_ccw, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '视角切换',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: views.map((view) {
                final isSelected = _selectedView == view;
                return ChoiceChip(
                  label: Text(view),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedView = view);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeridianSelector() {
    final meridians = [
      '任脉', '督脉', '肺经', '大肠经', '胃经', '脾经',
      '心经', '小肠经', '膀胱经', '肾经', '心包经', '三焦经', '胆经', '肝经',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.linear_scale, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '经络循行',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: meridians.map((meridian) {
                return ActionChip(
                  label: Text(meridian),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('显示$meridian循行路线')),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassicsTab() {
    final classics = _acupunctureService.getClassics();
    final schools = _acupunctureService.getSchools();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionTitle('经典古籍'),
        ...classics.map((classic) => _buildClassicCard(classic)),
        const SizedBox(height: 24),
        _buildSectionTitle('针灸流派'),
        ...schools.map((school) => _buildSchoolCard(school)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildClassicCard(AcupunctureClassic classic) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.menu_book, color: AppTheme.secondaryColor),
        ),
        title: Text(
          classic.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${classic.dynasty} · ${classic.author}'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classic.description,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    classic.content,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolCard(AcupunctureSchool school) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school, color: AppTheme.accentColor),
        ),
        title: Text(
          school.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(school.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSchoolSection('核心理论', school.theory),
                _buildSchoolSection('特色', school.features.join('、')),
                _buildSchoolSection('要点', school.keyPoints.join('\n• ')),
                _buildSchoolSection('技法', school.techniques.join('、')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildZibufaluzhuTab() {
    final zibufaluzhu = _acupunctureService.getZibufaluzhu();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time, color: AppTheme.accentColor),
                    SizedBox(width: 8),
                    Text(
                      '子午流注',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '气血按时辰流注经络脏腑',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...zibufaluzhu.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    item.hour.split('(')[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              title: Text('${item.meridian} · ${item.acupoint}'),
              subtitle: Text('${item.function} · ${item.indication}'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        }),
        const SizedBox(height: 24),
        _buildSectionTitle('灵龟八法'),
        _buildEightMethodCard('公孙', '冲脉', '胃心胸病症'),
        _buildEightMethodCard('内关', '阴维脉', '心胸胃病症'),
        _buildEightMethodCard('后溪', '督脉', '颈项腰背病症'),
        _buildEightMethodCard('申脉', '阳跷脉', '失眠眩晕'),
        _buildEightMethodCard('足临泣', '带脉', '胁肋病症'),
        _buildEightMethodCard('外关', '阳维脉', '外感热病'),
        _buildEightMethodCard('列缺', '任脉', '肺系咽喉病症'),
        _buildEightMethodCard('照海', '阴跷脉', '咽喉失眠'),
      ],
    );
  }

  Widget _buildEightMethodCard(String point, String meridian, String indication) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              point.substring(0, 2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
        ),
        title: Text(point),
        subtitle: Text('$meridian · $indication'),
      ),
    );
  }

  Widget _buildBoneMeasurementTab() {
    final measurements = _acupunctureService.getBoneMeasurements();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.straighten, color: AppTheme.primaryColor, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '骨度分寸',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '以患者本人身体长度为标准进行定位',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...measurements.map((m) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(m.name),
              subtitle: Text('${m.location} · ${m.measurement}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  m.measurement,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
              onTap: () {
                _showBoneDetail(m);
              },
            ),
          );
        }),
        const SizedBox(height: 24),
        _buildSectionTitle('体表找穴口诀'),
        _buildMnemonicCard('头项寻列缺', '头项部病症取列缺穴'),
        _buildMnemonicCard('面口合谷收', '面口部病症取合谷穴'),
        _buildMnemonicCard('腰背委中求', '腰背部病症取委中穴'),
        _buildMnemonicCard('肚腹三里留', '腹部病症取足三里'),
        _buildMnemonicCard('心胸内关谋', '心胸部病症取内关穴'),
        _buildMnemonicCard('妇科三阴交', '妇科病症取三阴交'),
      ],
    );
  }

  Widget _buildMnemonicCard(String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.blue.shade50,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.format_quote, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }

  void _showBoneDetail(BoneMeasurement m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(m.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('部位：${m.location}'),
            const SizedBox(height: 8),
            Text('长度：${m.measurement}'),
            const SizedBox(height: 8),
            Text('应用：${m.application}'),
          ],
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

  Widget _buildAIZuoxueTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: AppTheme.accentColor.withOpacity(0.1),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.accentColor, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI智能配穴',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '根据症状、脉象、舌苔自动配穴',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildAIInputSection(),
      ],
    );
  }

  Widget _buildAIInputSection() {
    final diseases = [
      '头痛/头晕', '失眠/多梦', '咳嗽/哮喘', '胃痛/腹胀',
      '腰痛/背痛', '月经不调', '感冒发热', '综合调理',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择症状类型',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: diseases.map((disease) {
                return ActionChip(
                  label: Text(disease),
                  onPressed: () {
                    _generateZuoxue(disease);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _generateZuoxue(String disease) {
    final zuoxue = _acupunctureService.generateZuoxue(
      symptoms: [disease],
      pulse: '',
      tongue: '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI配穴方案',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '基于$_selectedSchool理论',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildZuoxueSection('病症', zuoxue.disease),
                _buildZuoxueSection('涉及经络', zuoxue.meridian),
                _buildZuoxueSection('调理原则', zuoxue.principle),
                const SizedBox(height: 16),
                const Text(
                  '主穴',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: zuoxue.mainPoints.map((p) {
                    return Chip(
                      label: Text(p),
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '配穴',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: zuoxue.secondaryPoints.map((p) {
                    return Chip(
                      label: Text(p),
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '随证加减',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(zuoxue.adjunctPoints.join('\n')),
                ),
                const SizedBox(height: 16),
                const Text(
                  '配穴原理',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    zuoxue.explanation,
                    style: const TextStyle(height: 1.5),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildZuoxueSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }

  Widget _buildBeginnerTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBeginnerCard(
          '寸关尺布指',
          '诊脉时，医生用左手或右手的食指、中指和无名指诊脉。',
          Icons.pan_tool,
        ),
        _buildBeginnerCard(
          '脉象触感',
          '浮脉：轻取即得\n沉脉：重按始得\n滑脉：如珠走盘\n涩脉：如轻刀刮竹',
          Icons.touch_app,
        ),
        _buildBeginnerCard(
          '28种脉象',
          '浮、沉、迟、数、滑、涩、虚、实、长、短、洪、微、紧、缓、芤、弦、革、牢、濡、弱、散、细、伏、动、促、结、代、疾',
          Icons.list,
        ),
        _buildBeginnerCard(
          '舌诊要点',
          '舌色：淡红、淡白、红、绛、紫\n苔色：薄白、白、薄黄、黄、腻\n舌形：胖大、瘦薄、齿痕、裂纹',
          Icons.face,
        ),
        _buildBeginnerCard(
          '辨证要点',
          '寒热：舌淡白、脉迟=寒\n舌红、脉数=热\n虚实：脉虚、无力=虚\n脉实有力=实',
          Icons.psychology,
        ),
        _buildBeginnerCard(
          '开方配穴',
          '症状+脉象+舌苔=辨证\n辨证+经络=配穴\n主穴+配穴+随证加减',
          Icons.medical_services,
        ),
      ],
    );
  }

  Widget _buildBeginnerCard(String title, String content, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content, style: const TextStyle(height: 1.5)),
          ),
        ],
      ),
    );
  }
}
