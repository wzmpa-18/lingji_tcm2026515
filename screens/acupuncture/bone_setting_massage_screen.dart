import 'package:flutter/material.dart';
import '../../models/bone_setting_massage.dart';
import '../../config/theme.dart';

class BoneSettingMassageScreen extends StatefulWidget {
  const BoneSettingMassageScreen({super.key});

  @override
  State<BoneSettingMassageScreen> createState() => _BoneSettingMassageScreenState();
}

class _BoneSettingMassageScreenState extends State<BoneSettingMassageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = '全部';
  bool _showBooksOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('正骨推拿专区'),
        actions: [
          IconButton(
            icon: Icon(_showBooksOnly ? Icons.video_library : Icons.book),
            onPressed: () => setState(() => _showBooksOnly = !_showBooksOnly),
            tooltip: _showBooksOnly ? '视频教程' : '电子书',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '正骨流派'),
            Tab(text: '推拿按摩'),
            Tab(text: '经典书籍'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!_showBooksOnly) _buildCategoryFilter(),
          Expanded(
            child: _showBooksOnly
                ? _buildBooksView()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBoneSettingView(),
                      _buildMassageView(),
                      _buildBooksView(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: BoneSettingCategory.allCategories.length,
        itemBuilder: (context, index) {
          final category = BoneSettingCategory.allCategories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoneSettingView() {
    final techniques = _getBoneSettingTechniques();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: techniques.length,
      itemBuilder: (context, index) => _buildBoneSettingCard(techniques[index]),
    );
  }

  List<BoneSettingTechnique> _getBoneSettingTechniques() {
    return [
      BoneSettingTechnique(
        id: '1',
        name: '柔性正骨',
        origin: '源于传统中医正骨术',
        school: BoneSettingSchool.柔性正骨,
        principle: '以柔和之力，顺应骨骼自然走向，达到复位目的',
        features: '手法轻柔、无痛苦、安全性高、适用人群广',
        applicableConditions: [
          '颈椎病',
          '肩周炎',
          '腰椎间盘突出',
          '骨盆倾斜',
          '脊柱侧弯早期'
        ],
        contraindications: [
          '骨折急性期',
          '骨质疏松严重者',
          '恶性肿瘤骨转移',
          '严重心血管疾病'
        ],
        steps: [
          BoneSettingStep(
            stepNumber: 1,
            title: '放松肌肉',
            description: '使用揉法、滚法等手法放松局部肌肉',
            keyPoint: '力度均匀，循序渐进',
            techniques: ['揉法', '滚法', '拿法'],
            caution: '力度不宜过大',
            images: [],
            durationSeconds: 300,
          ),
          BoneSettingStep(
            stepNumber: 2,
            title: '评估检查',
            description: '触摸检查骨骼位置，确定偏移方向',
            keyPoint: '准确判断偏移类型',
            techniques: ['触诊法'],
            caution: '仔细对比双侧',
            images: [],
            durationSeconds: 180,
          ),
          BoneSettingStep(
            stepNumber: 3,
            title: '轻柔复位',
            description: '沿骨骼走向施以柔和推力',
            keyPoint: '顺势而为，切忌暴力',
            techniques: ['推法', '按法'],
            caution: '观察患者反应',
            images: [],
            durationSeconds: 240,
          ),
          BoneSettingStep(
            stepNumber: 4,
            title: '固定休息',
            description: '复位后适当固定，告知注意事项',
            keyPoint: '避免再次损伤',
            techniques: ['固定法'],
            caution: '24小时内避免剧烈活动',
            images: [],
            durationSeconds: 120,
          ),
        ],
        techniqueImages: [],
        videoUrls: [],
        history: '柔性正骨源自传统中医，历经数代传承发展而来',
        founder: '历代传承',
        createdAt: DateTime.now(),
      ),
      BoneSettingTechnique(
        id: '2',
        name: '美式正骨',
        origin: '美国脊骨神经医学',
        school: BoneSettingSchool.美式正骨,
        principle: '强调脊柱与神经系统的关系，通过调整脊椎恢复神经传导',
        features: '科学性强、注重整体、仪器辅助',
        applicableConditions: [
          '脊柱相关疾病',
          '椎间盘突出',
          '坐骨神经痛',
          '颈性头痛'
        ],
        contraindications: [
          '脊柱结核',
          '脊柱恶性肿瘤',
          '脊髓压迫症',
          '脊椎骨折'
        ],
        steps: [
          BoneSettingStep(
            stepNumber: 1,
            title: '神经检查',
            description: '评估神经功能状态',
            keyPoint: '全面了解病情',
            techniques: ['神经检查'],
            caution: '发现禁忌症及时转诊',
            images: [],
            durationSeconds: 300,
          ),
          BoneSettingStep(
            stepNumber: 2,
            title: '脊椎调整',
            description: '使用专门的手法或仪器进行调整',
            keyPoint: '精准定位',
            techniques: ['调整手法', '仪器辅助'],
            caution: '力度适中',
            images: [],
            durationSeconds: 360,
          ),
          BoneSettingStep(
            stepNumber: 3,
            title: '康复训练',
            description: '指导患者进行康复训练',
            keyPoint: '增强疗效',
            techniques: ['运动疗法'],
            caution: '循序渐进',
            images: [],
            durationSeconds: 300,
          ),
        ],
        techniqueImages: [],
        videoUrls: [],
        history: '美式正骨源于20世纪初的美国，由D.D.Palmer创立',
        founder: 'D.D.Palmer',
        createdAt: DateTime.now(),
      ),
      BoneSettingTechnique(
        id: '3',
        name: '龙氏正骨',
        origin: '广州龙层花创立',
        school: BoneSettingSchool.龙氏正骨,
        principle: '三步诊断法，结合中医经络理论与现代解剖学',
        features: '诊断精确、手法稳准轻柔、疗效显著',
        applicableConditions: [
          '颈椎病',
          '胸椎病',
          '腰椎病',
          '骨盆旋移'
        ],
        contraindications: [
          '脊椎结核',
          '脊椎肿瘤',
          '脊椎骨髓炎',
          '孕妇'
        ],
        steps: [
          BoneSettingStep(
            stepNumber: 1,
            title: '三步诊断',
            description: '望诊、触诊、影像学检查相结合',
            keyPoint: '明确病变部位',
            techniques: ['三步诊断'],
            caution: '综合分析',
            images: [],
            durationSeconds: 420,
          ),
          BoneSettingStep(
            stepNumber: 2,
            title: '摇正法',
            description: '利用脊柱运动进行复位',
            keyPoint: '顺势发力',
            techniques: ['摇正法'],
            caution: '控制幅度',
            images: [],
            durationSeconds: 300,
          ),
          BoneSettingStep(
            stepNumber: 3,
            title: '搬正法',
            description: '侧屈配合旋转进行复位',
            keyPoint: '精准发力',
            techniques: ['搬正法'],
            caution: '注意患者感受',
            images: [],
            durationSeconds: 240,
          ),
          BoneSettingStep(
            stepNumber: 4,
            title: '推正法',
            description: '俯卧位直接推正',
            keyPoint: '力度均匀',
            techniques: ['推正法'],
            caution: '避免急躁',
            images: [],
            durationSeconds: 180,
          ),
        ],
        techniqueImages: [],
        videoUrls: [],
        history: '龙氏正骨由龙层花教授创立于广州，历经50年发展完善',
        founder: '龙层花',
        createdAt: DateTime.now(),
      ),
      BoneSettingTechnique(
        id: '4',
        name: '罗氏正骨',
        origin: '北京罗有名创立',
        school: BoneSettingSchool.罗氏正骨,
        principle: '稳、准、轻、巧四字诀，强调手法技巧',
        features: '手法精妙、以巧破力、舒适安全',
        applicableConditions: [
          '骨折后遗症',
          '关节脱位',
          '软组织损伤',
          '各类骨伤'
        ],
        contraindications: [
          '新鲜骨折',
          '急性扭伤',
          '骨质疏松',
          '传染性疾病'
        ],
        steps: [
          BoneSettingStep(
            stepNumber: 1,
            title: '触摸诊断',
            description: '通过触摸判断骨位',
            keyPoint: '手感细腻',
            techniques: ['触诊'],
            caution: '仔细认真',
            images: [],
            durationSeconds: 300,
          ),
          BoneSettingStep(
            stepNumber: 2,
            title: '稳准手法',
            description: '准确判断，精准施法',
            keyPoint: '一步到位',
            techniques: ['稳准法'],
            caution: '切忌反复',
            images: [],
            durationSeconds: 240,
          ),
          BoneSettingStep(
            stepNumber: 3,
            title: '轻柔复位',
            description: '以巧破力，轻柔复位',
            keyPoint: '患者无痛苦',
            techniques: ['轻柔法'],
            caution: '避免暴力',
            images: [],
            durationSeconds: 300,
          ),
          BoneSettingStep(
            stepNumber: 4,
            title: '巧妙固定',
            description: '巧妙固定，促进愈合',
            keyPoint: '舒适有效',
            techniques: ['固定法'],
            caution: '松紧适度',
            images: [],
            durationSeconds: 180,
          ),
        ],
        techniqueImages: [],
        videoUrls: [],
        history: '罗氏正骨由罗有名创立，传承五代，在京城享有盛誉',
        founder: '罗有名',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Widget _buildBoneSettingCard(BoneSettingTechnique technique) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              technique.school.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          technique.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          technique.school.description,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('原理', technique.principle),
                const SizedBox(height: 8),
                _buildInfoRow('特点', technique.features),
                const SizedBox(height: 12),
                const Text(
                  '适用病症',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: technique.applicableConditions
                      .map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.green[50],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  '禁忌范围',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: technique.contraindications
                      .map((c) => Chip(
                            label: Text(c, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.red[50],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '分步手法教学',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ...technique.steps.map((step) => _buildStepCard(step)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.book),
                        label: const Text('阅读电子书'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.video_library),
                        label: const Text('视频教程'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(BoneSettingStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${step.stepNumber}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  step.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${step.durationSeconds ~/ 60}分钟',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.orange[700]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  step.keyPoint,
                  style: TextStyle(color: Colors.orange[700], fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: step.techniques
                .map((t) => Chip(
                      label: Text(t, style: const TextStyle(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ))
                .toList(),
          ),
          if (step.caution.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 14, color: Colors.amber[700]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '注意: ${step.caution}',
                      style: TextStyle(fontSize: 11, color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMassageView() {
    final techniques = _getMassageTechniques();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: techniques.length,
      itemBuilder: (context, index) => _buildMassageCard(techniques[index]),
    );
  }

  List<MassageTechnique> _getMassageTechniques() {
    return [
      MassageTechnique(
        id: '1',
        name: '全身推拿',
        type: MassageType.tuina,
        description: '传统中医推拿手法，调理全身经络',
        applicableConditions: ['疲劳', '失眠', '肩颈不适', '腰背酸痛'],
        contraindications: ['皮肤破损', '骨折', '高热'],
        steps: [
          MassageStep(
            stepNumber: 1,
            title: '头部按摩',
            description: '点按百会、风池等穴位',
            technique: '点按法',
            pressure: '中等',
            duration: 5,
            images: [],
            tip: '力度均匀',
          ),
          MassageStep(
            stepNumber: 2,
            title: '肩颈放松',
            description: '滚揉肩颈肌肉',
            technique: '滚法、揉法',
            pressure: '中等偏重',
            duration: 10,
            images: [],
            tip: '找准痛点',
          ),
          MassageStep(
            stepNumber: 3,
            title: '背部推拿',
            description: '沿膀胱经推按',
            technique: '推法、按法',
            pressure: '中等',
            duration: 15,
            images: [],
            tip: '顺着经络',
          ),
          MassageStep(
            stepNumber: 4,
            title: '四肢调理',
            description: '疏通四肢经络',
            technique: '拿法、揉法',
            pressure: '轻中度',
            duration: 10,
            images: [],
            tip: '注意关节',
          ),
        ],
        techniqueImages: [],
        duration: 60,
        difficulty: '中级',
        createdAt: DateTime.now(),
      ),
      MassageTechnique(
        id: '2',
        name: '足底反射疗法',
        type: MassageType.reflexology,
        description: '通过刺激足底反射区调节全身器官功能',
        applicableConditions: ['失眠', '消化不良', '头痛', '高血压'],
        contraindications: ['足部溃疡', '骨折', '静脉曲张'],
        steps: [
          MassageStep(
            stepNumber: 1,
            title: '足部放松',
            description: '温水泡脚后放松',
            technique: '揉捏法',
            pressure: '轻柔',
            duration: 5,
            images: [],
            tip: '水温适中',
          ),
          MassageStep(
            stepNumber: 2,
            title: '反射区按摩',
            description: '按压各器官对应反射区',
            technique: '拇指按压',
            pressure: '中等',
            duration: 25,
            images: [],
            tip: '由轻到重',
          ),
        ],
        techniqueImages: [],
        duration: 45,
        difficulty: '初级',
        createdAt: DateTime.now(),
      ),
    ];
  }

  Widget _buildMassageCard(MassageTechnique technique) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              technique.type.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          technique.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              technique.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text('${technique.duration}分钟', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(width: 12),
                Icon(Icons.trending_up, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(technique.difficulty, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_outline),
          onPressed: () {},
        ),
        onTap: () => _showMassageDetail(technique),
      ),
    );
  }

  void _showMassageDetail(MassageTechnique technique) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        technique.type.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          technique.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          technique.description,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(Icons.timer, '${technique.duration}分钟'),
                  const SizedBox(width: 8),
                  _buildInfoChip(Icons.trending_up, technique.difficulty),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '操作步骤',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: technique.steps.length,
                  itemBuilder: (context, index) {
                    final step = technique.steps[index];
                    return _buildMassageStepCard(step);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMassageStepCard(MassageStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step.stepNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${step.duration}分钟',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStepTag('手法: ${step.technique}'),
                const SizedBox(width: 8),
                _buildStepTag('力度: ${step.pressure}'),
              ],
            ),
            if (step.tip.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, size: 14, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      step.tip,
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }

  Widget _buildBooksView() {
    final books = _getBoneSettingBooks();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) => _buildBookCard(books[index]),
    );
  }

  List<BoneSettingBook> _getBoneSettingBooks() {
    return [
      BoneSettingBook(
        id: '1',
        title: '医宗金鉴·正骨心法要旨',
        author: '吴谦等',
        dynasty: '清代',
        description: '清代官修医学教科书，系统总结了正骨按摩的理论与实践',
        category: '正骨',
        coverImage: '',
        chapters: ['手法总论', '器具总论', '内治杂证', '陈旧损伤'],
        wordCount: 50000,
        isPremium: false,
        unlockPrice: 0,
        tags: ['经典', '官方', '教科书'],
        createdAt: DateTime.now(),
      ),
      BoneSettingBook(
        id: '2',
        title: '伤科补要',
        author: '钱秀昌',
        dynasty: '清代',
        description: '清代伤科专著，内容丰富，图文并茂',
        category: '正骨',
        coverImage: '',
        chapters: ['损伤总论', '各部损伤', '手法治疗', '药物治疗'],
        wordCount: 35000,
        isPremium: false,
        unlockPrice: 0,
        tags: ['伤科', '经典'],
        createdAt: DateTime.now(),
      ),
      BoneSettingBook(
        id: '3',
        title: '按摩经',
        author: '佚名',
        dynasty: '明代',
        description: '现存最早的按摩专著之一',
        category: '按摩',
        coverImage: '',
        chapters: ['总论', '手法', '各部按摩', '养生'],
        wordCount: 20000,
        isPremium: false,
        unlockPrice: 0,
        tags: ['古籍', '按摩'],
        createdAt: DateTime.now(),
      ),
      BoneSettingBook(
        id: '4',
        title: '推拿大成',
        author: '陈修园',
        dynasty: '清代',
        description: '推拿按摩集大成之作',
        category: '推拿',
        coverImage: '',
        chapters: ['总论', '手法详解', '常见病治疗', '养生保健'],
        wordCount: 60000,
        isPremium: true,
        unlockPrice: 100,
        tags: ['大成', '推拿', '会员'],
        createdAt: DateTime.now(),
      ),
    ];
  }

  Widget _buildBookCard(BoneSettingBook book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.menu_book, size: 40, color: AppTheme.primaryColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            book.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (book.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.diamond, size: 10, color: Colors.white),
                                const SizedBox(width: 2),
                                Text(
                                  '${book.unlockPrice}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${book.author} · ${book.dynasty}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.menu_book, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${book.chapters.length}章 · ${book.wordCount ~/ 1000}千字',
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                        ),
                        const Spacer(),
                        ...book.tags.take(2).map((tag) => Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(tag, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                            )),
                      ],
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
}
