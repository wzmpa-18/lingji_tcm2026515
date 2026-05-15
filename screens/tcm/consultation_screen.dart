import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../providers/tcm_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/consultation.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _symptoms = {};
  String? _selectedTongueColor;
  String? _selectedTongueCoating;
  String? _selectedPulse;
  String? _selectedMasterId;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    _selectedMasterId = user?.memberLevel == 0 ? 'master_1' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('全身问诊'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('选择名家'),
            _buildMasterSelector(),
            const SizedBox(height: 24),
            _buildSectionTitle('主要症状（可多选）'),
            _buildSymptomsGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('其他症状描述'),
            _buildTextArea('symptoms_text'),
            const SizedBox(height: 24),
            _buildSectionTitle('舌诊'),
            _buildTongueDiagnosis(),
            const SizedBox(height: 24),
            _buildSectionTitle('脉诊'),
            _buildPulseDiagnosis(),
            const SizedBox(height: 24),
            _buildSectionTitle('补充说明'),
            _buildTextArea('additional'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitConsultation,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('提交问诊', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/tcm/tongue'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('舌象拍照分析', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/tcm/pulse'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('脉象分析', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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

  Widget _buildMasterSelector() {
    return Consumer<TCMProvider>(
      builder: (context, provider, _) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provider.masters.map((master) {
            final isSelected = _selectedMasterId == master.id;
            return ChoiceChip(
              label: Text(master.name),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedMasterId = master.id);
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildSymptomsGrid() {
    final symptoms = [
      '发热', '恶寒', '头痛', '咳嗽', '咽干', '咽痛',
      '胸闷', '心悸', '胁痛', '脘腹胀满', '腹痛', '腹泻',
      '便秘', '呕吐', '恶心', '食欲不振', '乏力', '盗汗',
      '自汗', '失眠', '多梦', '头晕', '耳鸣', '眼花',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: symptoms.map((symptom) {
        final isSelected = _symptoms[symptom] == true;
        return FilterChip(
          label: Text(symptom),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _symptoms[symptom] = selected;
            });
          },
          selectedColor: AppTheme.primaryColor.withOpacity(0.2),
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }

  Widget _buildTextArea(String key) {
    return TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: '请详细描述...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _symptoms[key] = value;
      },
    );
  }

  Widget _buildTongueDiagnosis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('舌色', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.tongueColors.map((color) {
            final isSelected = _selectedTongueColor == color;
            return ChoiceChip(
              label: Text(color),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedTongueColor = color);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('苔色', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.tongueCoatings.map((coating) {
            final isSelected = _selectedTongueCoating == coating;
            return ChoiceChip(
              label: Text(coating),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedTongueCoating = coating);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPulseDiagnosis() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.pulseTypes.map((pulse) {
        final isSelected = _selectedPulse == pulse;
        return ChoiceChip(
          label: Text(pulse),
          selected: isSelected,
          onSelected: (_) {
            setState(() => _selectedPulse = pulse);
          },
        );
      }).toList(),
    );
  }

  Future<void> _submitConsultation() async {
    if (_symptoms.isEmpty && _selectedTongueColor == null && _selectedPulse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少填写一项症状'), backgroundColor: Colors.orange),
      );
      return;
    }

    final user = context.read<UserProvider>().currentUser;
    if (user == null) return;

    final consultation = Consultation(
      id: const Uuid().v4(),
      userId: user.id,
      symptoms: _symptoms,
      tongue: _selectedTongueColor != null
          ? '$_selectedTongueColor舌, $_selectedTongueCoating苔'
          : null,
      pulse: _selectedPulse,
      masterId: _selectedMasterId,
      createdAt: DateTime.now(),
    );

    await context.read<TCMProvider>().saveConsultation(consultation);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('问诊记录已保存'), backgroundColor: Colors.green),
      );
      context.go('/tcm');
    }
  }
}
