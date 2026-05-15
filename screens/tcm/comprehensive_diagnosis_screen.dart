import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../services/herb_service.dart';
import '../../services/acupuncture_service.dart';
import '../../services/database_service.dart';
import '../../models/consultation.dart';
import '../../models/herb.dart';
import '../../models/acupuncture_class.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class ComprehensiveDiagnosisScreen extends StatefulWidget {
  const ComprehensiveDiagnosisScreen({super.key});

  @override
  State<ComprehensiveDiagnosisScreen> createState() => _ComprehensiveDiagnosisScreenState();
}

class _ComprehensiveDiagnosisScreenState extends State<ComprehensiveDiagnosisScreen> {
  final HerbService _herbService = HerbService();
  final AcupunctureService _acupunctureService = AcupunctureService();
  
  final Map<String, bool> _symptoms = {};
  final TextEditingController _symptomDetailController = TextEditingController();
  
  String _tongueColor = '';
  String _tongueCoating = '';
  String _tongueShape = '';
  String _tongueMoisture = '';
  
  String _pulseType = '';
  String _pulseLocation = '';
  String _pulseForce = '';
  
  String? _selectedSchool;
  Prescription? _prescription;
  AIZuoxue? _zuoxue;
  FormulaAnalysis? _analysis;
  bool _isGenerating = false;

  final List<String> _allSymptoms = [
    '发热', '恶寒', '畏寒', '寒热往来',
    '头痛', '头晕', '头重', '头胀',
    '胸闷', '心悸', '胸痛', '胁痛',
    '咳嗽', '气喘', '咽干', '咽痛',
    '胃脘痛', '腹胀', '腹痛', '恶心',
    '呕吐', '腹泻', '便秘', '食欲不振',
    '乏力', '盗汗', '自汗', '失眠',
    '多梦', '烦躁', '口苦', '口干',
    '腰酸', '腰痛', '四肢麻木', '肢体疼痛',
    '月经不调', '痛经', '白带异常', '阳痿',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSchool = '倪海厦针灸';
  }

  @override
  void dispose() {
    _symptomDetailController.dispose();
    super.dispose();
  }

  Future<void> _generateComprehensiveDiagnosis() async {
    if (_symptoms.isEmpty && _tongueColor.isEmpty && _pulseType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一项或输入症状'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isGenerating = true);

    await Future.delayed(const Duration(seconds: 2));

    final formulas = await DatabaseService().getPrescriptions(masterId: 'master_1');
    final selectedSymptomList = _symptoms.keys.toList();

    Prescription? matchedFormula;
    for (var formula in formulas) {
      if (selectedSymptomList.any((s) => formula.indications.contains(s))) {
        matchedFormula = formula;
        break;
      }
    }

    if (matchedFormula == null && formulas.isNotEmpty) {
      matchedFormula = formulas.first;
    }

    final user = context.read<UserProvider>().currentUser;
    final memberLevel = user?.memberLevel ?? 0;

    FormulaAnalysis? analysis;
    if (matchedFormula != null) {
      analysis = _herbService.generateFormulaAnalysis(
        formula: matchedFormula,
        symptoms: selectedSymptomList,
        tongue: '$_tongueColor舌, $_tongueCoating苔',
        pulse: _pulseType,
        memberLevel: memberLevel,
      );
    }

    final zuoxue = _acupunctureService.generateZuoxue(
      symptoms: selectedSymptomList,
      pulse: _pulseType,
      tongue: '$_tongueColor舌',
    );

    setState(() {
      _prescription = matchedFormula;
      _analysis = analysis;
      _zuoxue = zuoxue;
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('三合一综合辨证'),
      ),
      body: _prescription == null ? _buildInputForm() : _buildResultView(),
    );
  }

  Widget _buildInputForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSchoolSelector(),
        const SizedBox(height: 16),
        _buildSymptomSelector(),
        const SizedBox(height: 16),
        _buildTongueDiagnosis(),
        const SizedBox(height: 16),
        _buildPulseDiagnosis(),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isGenerating ? null : _generateComprehensiveDiagnosis,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: _isGenerating
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text('AI综合辨证中...'),
                  ],
                )
              : const Text('AI综合辨证开方', style: TextStyle(fontSize: 18)),
        ),
        const SizedBox(height: 32),
      ],
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
                  '选择针灸流派',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildSymptomSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.healing, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '自觉症状（可多选）',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '已选${_symptoms.length}项',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSymptoms.map((symptom) {
                final isSelected = _symptoms[symptom] == true;
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _symptoms[symptom] = selected);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _symptomDetailController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '其他症状描述',
                hintText: '请详细描述您的其他症状...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTongueDiagnosis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.face, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '舌象诊断',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('舌色', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.tongueColors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _tongueColor == color,
                  onSelected: (_) => setState(() => _tongueColor = color),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('苔色', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.tongueCoatings.map((coating) {
                return ChoiceChip(
                  label: Text(coating),
                  selected: _tongueCoating == coating,
                  onSelected: (_) => setState(() => _tongueCoating = coating),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('舌形', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['胖大', '瘦薄', '齿痕', '裂纹', '正常'].map((shape) {
                return ChoiceChip(
                  label: Text(shape),
                  selected: _tongueShape == shape,
                  onSelected: (_) => setState(() => _tongueShape = shape),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('润燥', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['润', '燥'].map((m) {
                return ChoiceChip(
                  label: Text(m),
                  selected: _tongueMoisture == m,
                  onSelected: (_) => setState(() => _tongueMoisture = m),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulseDiagnosis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '脉象诊断',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('寸关尺位置', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['寸', '关', '尺', '浮', '中', '沉'].map((loc) {
                return ChoiceChip(
                  label: Text(loc),
                  selected: _pulseLocation == loc,
                  onSelected: (_) => setState(() => _pulseLocation = loc),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('脉型', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.pulseTypes.map((pulse) {
                return ChoiceChip(
                  label: Text(pulse, style: const TextStyle(fontSize: 12)),
                  selected: _pulseType == pulse,
                  onSelected: (_) => setState(() => _pulseType = pulse),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text('脉力', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['有力', '无力', '中等'].map((force) {
                return ChoiceChip(
                  label: Text(force),
                  selected: _pulseForce == force,
                  onSelected: (_) => setState(() => _pulseForce = force),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDiagnosisHeader(),
        const SizedBox(height: 16),
        _buildSyndromeAnalysis(),
        const SizedBox(height: 16),
        if (_prescription != null && _analysis != null) ...[
          _buildPrescriptionResult(),
          const SizedBox(height: 16),
        ],
        if (_zuoxue != null) ...[
          _buildZuoxueResult(),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _prescription = null;
                    _analysis = null;
                    _zuoxue = null;
                  });
                },
                child: const Text('重新辨证'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('方案已保存')),
                  );
                },
                child: const Text('保存方案'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDiagnosisHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'AI综合辨证结果',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDiagnosisBadge('辨证', _getSyndromeDiagnosis()),
              _buildDiagnosisBadge('治则', _getTreatmentPrinciple()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisBadge(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getSyndromeDiagnosis() {
    if (_tongueColor.contains('淡') || _pulseType.contains('迟')) return '虚寒证';
    if (_tongueColor.contains('红') || _pulseType.contains('数')) return '实热证';
    if (_symptoms.containsKey('胸闷') || _symptoms.containsKey('胁痛')) return '肝郁证';
    if (_symptoms.containsKey('胃脘痛') || _symptoms.containsKey('腹胀')) return '脾胃证';
    return '综合证';
  }

  String _getTreatmentPrinciple() {
    if (_tongueColor.contains('淡')) return '补益气血';
    if (_tongueColor.contains('红')) return '清热泻火';
    if (_symptoms.containsKey('胸闷')) return '疏肝理气';
    if (_symptoms.containsKey('胃脘痛')) return '和胃止痛';
    return '调和脏腑';
  }

  Widget _buildSyndromeAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.psychology, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '辨证分析',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAnalysisItem('症状分析', _symptoms.keys.isNotEmpty 
                ? _symptoms.keys.take(5).join('、') 
                : '无'),
            _buildAnalysisItem('舌象', '$_tongueColor舌, $_tongueCoating苔${_tongueShape.isNotEmpty ? '(${_tongueShape})' : ''}'),
            _buildAnalysisItem('脉象', '$_pulseLocation$_pulseType脉${_pulseForce.isNotEmpty ? '($_pulseForce)' : ''}'),
            _buildAnalysisItem('辨证', _getSyndromeDiagnosis()),
            _buildAnalysisItem('治则', _getTreatmentPrinciple()),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildPrescriptionResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medication, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '中药处方',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '倪海厦配方',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              _prescription!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              '出处：${_prescription!.origin}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              '主治：${_prescription!.indications}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              '组成',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _prescription!.composition.map((herb) {
                return Chip(
                  label: Text('${herb['herb']} ${herb['dosage']}'),
                );
              }).toList(),
            ),
            if (_analysis != null) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('倪海厦教学解析'),
                leading: const Icon(Icons.school, color: AppTheme.primaryColor),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _analysis!.selectReason,
                      style: const TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildZuoxueResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.spa, color: AppTheme.secondaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '针灸配穴',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _selectedSchool ?? '',
                    style: const TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(
              '调理原则：${_zuoxue!.principle}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              '涉及经络：${_zuoxue!.meridian}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Text(
              '主穴',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _zuoxue!.mainPoints.map((p) {
                return Chip(
                  label: Text(p),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              '配穴',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _zuoxue!.secondaryPoints.map((p) {
                return Chip(
                  label: Text(p),
                  backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: const Text('配穴原理'),
              leading: const Icon(Icons.lightbulb, color: AppTheme.accentColor),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _zuoxue!.explanation,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '随证加减',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_zuoxue!.adjunctPoints.join('\n')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
