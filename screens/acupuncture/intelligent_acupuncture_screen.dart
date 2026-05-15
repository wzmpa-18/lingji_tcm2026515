import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/acupuncture_provider.dart';
import '../../services/acupuncture/acupuncture_prescription_service.dart';
import '../../config/theme.dart';

class IntelligentAcupunctureScreen extends StatefulWidget {
  const IntelligentAcupunctureScreen({super.key});

  @override
  State<IntelligentAcupunctureScreen> createState() => _IntelligentAcupunctureScreenState();
}

class _IntelligentAcupunctureScreenState extends State<IntelligentAcupunctureScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  final List<String> _bodyRegions = [
    '頭部', '面部', '頸部', '胸部', '背部', '腹部',
    '手臂', '手部', '大腿', '小腿', '足部',
  ];

  final List<String> _painCharacters = [
    '脹痛', '刺痛', '灼痛', '隱痛', '劇痛', '鈍痛', '遊走痛', '固定痛',
  ];

  final List<String> _painTimings = [
    '持續', '陣發', '發作性', '定時發作', '活動後加重', '休息後緩解',
  ];

  final List<String> _tongueColors = [
    '淡紅', '紅', '絳紅', '淡白', '青紫', '暗淡',
  ];

  final List<String> _tongueCoatings = [
    '薄白', '薄黃', '黃膩', '白膩', '少苔', '無苔', '剝苔',
  ];

  final List<String> _pulseTypes = [
    '浮', '沉', '遲', '數', '滑', '澀', '虛', '實', '弦', '緊', '洪', '細', '弱', '緩',
  ];

  String? _selectedRegion;
  final Set<String> _selectedSymptoms = {};
  String? _selectedPainCharacter;
  String? _selectedPainTiming;
  String? _selectedTongueColor;
  String? _selectedTongueCoating;
  String? _selectedPulseType;
  int? _age;
  bool _isPregnant = false;
  final List<String> _medicalHistory = [];
  bool _isAcute = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能辨證配針'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBodyRegionPage(),
                _buildSymptomsPage(),
                _buildTonguePulsePage(),
                _buildPersonalInfoPage(),
                _buildDiagnosisResultPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
              child: isCompleted
                  ? const SizedBox()
                  : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBodyRegionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '第一步：選擇不適部位',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '請選擇您感到不適的身體部位（可多選）',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bodyRegions.map((region) {
              final isSelected = _selectedRegion == region;
              return FilterChip(
                label: Text(region),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedRegion = selected ? region : null;
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildStepButtons(),
        ],
      ),
    );
  }

  Widget _buildSymptomsPage() {
    final symptomsForRegion = _getSymptomsForRegion(_selectedRegion ?? '');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第二步：選擇具體症狀（$_selectedRegion）',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '請選擇您感受到的症狀（可多選）',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...symptomsForRegion.map((symptom) {
            return CheckboxListTile(
              title: Text(symptom),
              value: _selectedSymptoms.contains(symptom),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedSymptoms.add(symptom);
                  } else {
                    _selectedSymptoms.remove(symptom);
                  }
                });
              },
              activeColor: AppTheme.primaryColor,
            );
          }),
          const Divider(),
          const Text(
            '疼痛性質（可選）',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _painCharacters.map((char) {
              final isSelected = _selectedPainCharacter == char;
              return FilterChip(
                label: Text(char),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPainCharacter = selected ? char : null;
                  });
                },
                selectedColor: AppTheme.accentColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '疼痛時間特點（可選）',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _painTimings.map((timing) {
              final isSelected = _selectedPainTiming == timing;
              return FilterChip(
                label: Text(timing),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPainTiming = selected ? timing : null;
                  });
                },
                selectedColor: AppTheme.accentColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            title: const Text('是否急性發作（近期發病）'),
            value: _isAcute,
            onChanged: (value) {
              setState(() {
                _isAcute = value ?? false;
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(height: 24),
          _buildStepButtons(),
        ],
      ),
    );
  }

  Widget _buildTonguePulsePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '第三步：舌脈辨證（可選填）',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '如有中醫診斷資料請填寫，否則系統將根據症狀辨證',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          const Text(
            '舌質顏色',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tongueColors.map((color) {
              final isSelected = _selectedTongueColor == color;
              return ChoiceChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTongueColor = selected ? color : null;
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '舌苔',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tongueCoatings.map((coating) {
              final isSelected = _selectedTongueCoating == coating;
              return ChoiceChip(
                label: Text(coating),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedTongueCoating = selected ? coating : null;
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '脈象',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _pulseTypes.map((pulse) {
              final isSelected = _selectedPulseType == pulse;
              return ChoiceChip(
                label: Text(pulse),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPulseType = selected ? pulse : null;
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          _buildStepButtons(),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '第四步：個人資訊（可選填）',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '請填寫以下資訊以便系統更準確地為您配穴',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('年齡'),
            subtitle: Text(_age != null ? '$_age 歲' : '未填寫'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAgePicker(),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('孕婦'),
            subtitle: const Text('孕婦需特別注意穴位選擇'),
            value: _isPregnant,
            onChanged: (value) {
              setState(() {
                _isPregnant = value;
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            '既往病史（可多選）',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '心臟病', '高血壓', '糖尿病', '腎病', '肝病', '血液病', '骨質疏鬆',
            ].map((history) {
              final isSelected = _medicalHistory.contains(history);
              return FilterChip(
                label: Text(history),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _medicalHistory.add(history);
                    } else {
                      _medicalHistory.remove(history);
                    }
                  });
                },
                selectedColor: AppTheme.errorColor.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _performDiagnosis,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('開始智能辨證配針'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.accentColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildStepButtons(showBack: true),
        ],
      ),
    );
  }

  Widget _buildDiagnosisResultPage() {
    return Consumer<AcupunctureProvider>(
      builder: (context, provider, _) {
        if (provider.isDiagnosing) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在分析您的症狀...'),
              ],
            ),
          );
        }

        final diagnosis = provider.currentDiagnosis;
        final prescriptions = provider.currentPrescriptions;
        final mainPoints = provider.getMainPoints();
        final pairedPoints = provider.getPairedPoints();
        final dongPrescriptions = provider.getDongPrescriptions();
        final niHaixiaPrescriptions = provider.getNiHaixiaPrescriptions();
        final traditionalPrescriptions = provider.getTraditionalPrescriptions();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '辨證結果',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                color: AppTheme.primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.healing, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            '辨證分型：${diagnosis?.syndromeName ?? ''}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '治療原則：${diagnosis?.therapeuticPrinciple ?? ''}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '治療策略：${diagnosis?.treatmentStrategy ?? ''}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (diagnosis?.riskFactors.isNotEmpty ?? false) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.orange, size: 18),
                                  SizedBox(width: 4),
                                  Text('注意事項', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              ...diagnosis!.riskFactors.map((risk) => Text('• $risk')),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '配針方案',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '共 ${prescriptions.length} 個穴位',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              if (dongPrescriptions.isNotEmpty) ...[
                _buildPrescriptionSection(
                  '董氏奇穴',
                  Icons.spa,
                  Colors.green,
                  dongPrescriptions,
                ),
                const SizedBox(height: 16),
              ],
              if (niHaixiaPrescriptions.isNotEmpty) ...[
                _buildPrescriptionSection(
                  '倪海厦特效穴',
                  Icons.auto_awesome,
                  Colors.purple,
                  niHaixiaPrescriptions,
                ),
                const SizedBox(height: 16),
              ],
              if (traditionalPrescriptions.isNotEmpty) ...[
                _buildPrescriptionSection(
                  '傳統經穴',
                  Icons.medical_services,
                  Colors.blue,
                  traditionalPrescriptions,
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 24),
              _buildOperationNotes(),
              const SizedBox(height: 24),
              _buildStepButtons(showBack: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionSection(
    String title,
    IconData icon,
    Color color,
    List<AcupuncturePrescription> prescriptions,
  ) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text('${prescriptions.length} 個穴位'),
        children: prescriptions.map((p) {
          return ListTile(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.isMainPoint ? color : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    p.isMainPoint ? '主穴' : '配穴',
                    style: TextStyle(
                      color: p.isMainPoint ? Colors.white : Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(p.acupointName),
                const SizedBox(width: 4),
                Text(
                  p.acupointNamePinyin,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('主治：${p.clinicalNote}', maxLines: 2),
                const SizedBox(height: 4),
                Text(
                  '選穴原理：${p.principle}',
                  style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 4),
                Text(
                  '針刺：${p.needleDepth}，${p.manipulation}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                if (p.contraindication.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '禁忌：${p.contraindication}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ),
            isThreeLine: true,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOperationNotes() {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  '操作要點',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('• 每次治療選取4-10個穴位為宜'),
            const Text('• 主穴先行針刺，獲得針感後再刺配穴'),
            const Text('• 留針20-30分鐘，每10分鐘行針1次'),
            const Text('• 慢性病每週治療2-3次，急性病可每日治療'),
            const Text('• 孕婦及特殊人群請在醫師指導下操作'),
            const SizedBox(height: 8),
            const Text(
              '本方案僅供參考，具體治療請諮詢執業中醫師',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepButtons({bool showBack = false}) {
    return Row(
      children: [
        if (showBack)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              child: const Text('上一步'),
            ),
          ),
        if (showBack) const SizedBox(width: 16),
        if (_currentStep < 4 && !showBack)
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedRegion != null || _selectedSymptoms.isNotEmpty
                  ? _nextStep
                  : null,
              child: const Text('下一步'),
            ),
          ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showAgePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('選擇年齡'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                final age = index + 1;
                return ListTile(
                  title: Text('$age 歲'),
                  onTap: () {
                    setState(() {
                      _age = age;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _performDiagnosis() {
    final provider = context.read<AcupunctureProvider>();
    provider.performDiagnosis(
      mainSymptoms: _selectedSymptoms.toList(),
      painLocation: _selectedRegion ?? '',
      painCharacter: _selectedPainCharacter ?? '',
      painTiming: _selectedPainTiming ?? '',
      isAcute: _isAcute,
      tongueColor: _selectedTongueColor,
      tongueCoating: _selectedTongueCoating,
      pulseType: _selectedPulseType,
      age: _age,
      isPregnant: _isPregnant,
      medicalHistory: _medicalHistory,
    );

    setState(() {
      _currentStep = 4;
    });
    _pageController.jumpToPage(4);
  }

  List<String> _getSymptomsForRegion(String region) {
    final symptomsMap = {
      '頭部': ['頭痛', '頭暈', '眩暈', '頭脹', '脫髮', '失眠', '記憶力減退'],
      '面部': ['面癱', '面痛', '面部麻木', '痤瘡', '黃褐斑', '三叉神經痛'],
      '頸部': ['頸項強痛', '頸椎病', '落枕', '甲狀腺腫', '咽喉不適'],
      '胸部': ['胸悶', '胸痛', '心悸', '咳嗽', '氣喘', '乳腺疾病'],
      '背部': ['背痛', '肩胛痛', '脊柱側彎', '背部僵硬'],
      '腹部': ['胃痛', '腹痛', '腹脹', '腹瀉', '便秘', '月經失調', '痛經'],
      '手臂': ['肩周炎', '手臂疼痛', '手臂麻木', '網球肘', '高爾夫球肘'],
      '手部': ['手指麻木', '腕管綜合徵', '腱鞘炎', '類風濕關節炎'],
      '大腿': ['大腿疼痛', '大腿麻木', '股骨頭壞死'],
      '小腿': ['小腿疼痛', '小腿麻木', '靜脈曲張', '腿抽筋', '膝蓋痛'],
      '足部': ['足跟痛', '踝關節扭傷', '足底筋膜炎', '痛風', '拇外翻'],
    };
    return symptomsMap[region] ?? [];
  }
}
