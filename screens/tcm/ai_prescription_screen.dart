import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../providers/tcm_provider.dart';
import '../../services/herb_service.dart';
import '../../services/database_service.dart';
import '../../models/consultation.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import 'ai_analysis_screen.dart';

class AIPrescriptionScreen extends StatefulWidget {
  const AIPrescriptionScreen({super.key});

  @override
  State<AIPrescriptionScreen> createState() => _AIPrescriptionScreenState();
}

class _AIPrescriptionScreenState extends State<AIPrescriptionScreen> {
  final HerbService _herbService = HerbService();
  final DatabaseService _dbService = DatabaseService();
  
  String? _selectedMasterId;
  List<String> _selectedSymptoms = [];
  String _tongueColor = '';
  String _tongueCoating = '';
  String _pulseType = '';
  List<Prescription> _recommendedFormulas = [];
  bool _isAnalyzing = false;

  final List<String> _commonSymptoms = [
    '发热', '恶寒', '头痛', '咳嗽', '咽干', '咽痛',
    '胸闷', '心悸', '胁痛', '脘腹胀满', '腹痛', '便秘',
    '腹泻', '呕吐', '恶心', '食欲不振', '乏力', '失眠',
    '多梦', '头晕', '耳鸣', '汗出', '畏寒', '口苦',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMasterId = 'master_1';
  }

  Future<void> _analyzeAndPrescribe() async {
    if (_selectedSymptoms.isEmpty && _tongueColor.isEmpty && _pulseType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一项症状'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(seconds: 2));

    final formulas = await _dbService.getPrescriptions(masterId: _selectedMasterId);
    
    final filteredFormulas = formulas.where((f) {
      final indication = f.indications.toLowerCase();
      return _selectedSymptoms.any((s) => indication.contains(s.toLowerCase()));
    }).toList();

    if (filteredFormulas.isEmpty && formulas.isNotEmpty) {
      filteredFormulas.addAll(formulas.take(3));
    }

    setState(() {
      _recommendedFormulas = filteredFormulas;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;
    final isHighMember = (user?.memberLevel ?? 0) >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI智能开方'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => context.push('/tcm/herb-database'),
            tooltip: '药材数据库',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMasterSelector(),
          const SizedBox(height: 16),
          _buildSymptomsSelector(),
          const SizedBox(height: 16),
          _buildTongueDiagnosis(),
          const SizedBox(height: 16),
          _buildPulseDiagnosis(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isAnalyzing ? null : _analyzeAndPrescribe,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isAnalyzing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text('AI分析中...'),
                    ],
                  )
                : const Text('AI智能开方', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(height: 24),
          if (_recommendedFormulas.isNotEmpty) _buildRecommendedFormulas(isHighMember),
        ],
      ),
    );
  }

  Widget _buildMasterSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: AppTheme.primaryColor),
                SizedBox(width: 8),
                Text(
                  '选择经方名家',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<TCMProvider>(
              builder: (context, provider, _) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.masters.map((master) {
                    final isSelected = _selectedMasterId == master.id;
                    return ChoiceChip(
                      label: Text('${master.name} (${master.dynasty})'),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedMasterId = master.id);
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSelector() {
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
                    '选择主要症状（可多选）',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '已选${_selectedSymptoms.length}项',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonSymptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                );
              }).toList(),
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('舌色', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.tongueColors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _tongueColor == color,
                  onSelected: (_) {
                    setState(() => _tongueColor = color);
                  },
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
                  onSelected: (_) {
                    setState(() => _tongueCoating = coating);
                  },
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
              children: AppConstants.pulseTypes.map((pulse) {
                return ChoiceChip(
                  label: Text(pulse),
                  selected: _pulseType == pulse,
                  onSelected: (_) {
                    setState(() => _pulseType = pulse);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedFormulas(bool isHighMember) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppTheme.accentColor),
            const SizedBox(width: 8),
            const Text(
              '推荐经方',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (!isHighMember)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '高级会员解锁全部功能',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ..._recommendedFormulas.map((formula) {
          return _buildFormulaCard(formula, isHighMember);
        }),
      ],
    );
  }

  Widget _buildFormulaCard(Prescription formula, bool isHighMember) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIAnalysisScreen(
                formulaName: formula.name,
                formula: formula,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        formula.name.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formula.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formula.origin,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'AI解析',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                formula.indications,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: formula.composition.take(5).map((herb) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${herb['herb']}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AIAnalysisScreen(
                              formulaName: formula.name,
                              formula: formula,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 16),
                      label: Text(isHighMember ? '查看倪海厦教学解析' : '查看倪海厦教学解析'),
                    ),
                  ),
                ],
              ),
              if (!isHighMember) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '高级会员专享：分阶段调理效果、随证加减指导',
                          style: TextStyle(fontSize: 12, color: Colors.amber),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/my/member'),
                        child: const Text('开通'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
