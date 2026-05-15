import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/tcm_provider.dart';
import '../../models/consultation.dart';
import '../../config/theme.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  String _selectedCategory = '全部';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TCMProvider>().loadPrescriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('经方库'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMastersDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMasterSelector(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildPrescriptionList()),
        ],
      ),
    );
  }

  Widget _buildMasterSelector() {
    return Consumer<TCMProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(12),
          color: AppTheme.surfaceColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '辨证模式：',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('单选'),
                    selected: !provider.isMultiSelect,
                    onSelected: (_) => provider.setMultiSelect(false),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('多选'),
                    selected: provider.isMultiSelect,
                    onSelected: (_) => provider.setMultiSelect(true),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!provider.isMultiSelect)
                DropdownButton<Master>(
                  value: provider.selectedMaster,
                  isExpanded: true,
                  hint: const Text('选择名家'),
                  items: provider.masters.map((master) {
                    return DropdownMenuItem(
                      value: master,
                      child: Text('${master.name} (${master.dynasty})'),
                    );
                  }).toList(),
                  onChanged: (master) {
                    if (master != null) {
                      provider.setSelectedMaster(master);
                    }
                  },
                )
              else
                Wrap(
                  spacing: 8,
                  children: provider.masters.map((master) {
                    final isSelected = provider.selectedMasters.contains(master.id);
                    return FilterChip(
                      label: Text(master.name),
                      selected: isSelected,
                      onSelected: (_) => provider.toggleMasterSelection(master.id),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索经方名称、功效、药材...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<TCMProvider>(
      builder: (context, provider, _) {
        final categories = ['全部', '解表剂', '和解剂', '清热剂', '温里剂', '补益剂', '理气剂', '理血剂'];
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedCategory = cat);
                    provider.loadPrescriptions(
                      category: cat == '全部' ? null : cat,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPrescriptionList() {
    return Consumer<TCMProvider>(
      builder: (context, provider, _) {
        final prescriptions = _searchQuery.isEmpty
            ? provider.prescriptions
            : provider.searchPrescriptions(_searchQuery);

        if (prescriptions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('暂无经方', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final rx = prescriptions[index];
            return _buildPrescriptionCard(rx);
          },
        );
      },
    );
  }

  Widget _buildPrescriptionCard(Prescription rx) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showPrescriptionDetail(rx),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      rx.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      rx.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '出处：${rx.origin}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                rx.indications,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: rx.composition.take(5).map((herb) {
                  return Chip(
                    label: Text(
                      '${herb['herb']} ${herb['dosage']}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrescriptionDetail(Prescription rx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
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
                Text(
                  rx.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '出处：${rx.origin}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                _buildSection('组成', rx.composition.map((c) => '${c['herb']} ${c['dosage']}').join('、')),
                _buildSection('功效主治', rx.indications),
                _buildSection('用法用量', rx.usage),
                if (rx.contraindications != null)
                  _buildSection('禁忌', rx.contraindications!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.6),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _showMastersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('十大名家简介'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMasterInfo('倪海厦', '现代', '伤寒论权威，倪氏中医创始人'),
              _buildMasterInfo('张仲景', '东汉', '《伤寒论》作者，医圣'),
              _buildMasterInfo('胡希恕', '现代', '经方大师，伤寒论专家'),
              _buildMasterInfo('黄煌', '现代', '经方家，南京中医药大学教授'),
              _buildMasterInfo('李可', '现代', '火神派代表，善用附子'),
              _buildMasterInfo('曹颖甫', '近代', '经方实验家'),
              _buildMasterInfo('许叔微', '宋代', '《普济本事方》作者'),
              _buildMasterInfo('叶天士', '清代', '温病学派创始人'),
              _buildMasterInfo('吴鞠通', '清代', '《温病条辨》作者'),
              _buildMasterInfo('傅青主', '清代', '妇科圣手，《傅青主女科》'),
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

  Widget _buildMasterInfo(String name, String dynasty, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
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
                  '$name ($dynasty)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
