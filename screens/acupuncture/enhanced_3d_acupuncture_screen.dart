import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/acupuncture_provider.dart';
import '../../models/acupuncture/dong_acupoint.dart';
import '../../models/acupuncture/nihaixia_acupoint.dart';
import '../../models/acupoint.dart';
import '../../config/theme.dart';

class Enhanced3DAcupunctureScreen extends StatefulWidget {
  const Enhanced3DAcupunctureScreen({super.key});

  @override
  State<Enhanced3DAcupunctureScreen> createState() => _Enhanced3DAcupunctureScreenState();
}

class _Enhanced3DAcupunctureScreenState extends State<Enhanced3DAcupunctureScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _currentSystem = 'traditional';
  String _currentRegion = 'all';
  String _searchQuery = '';
  int _bodyLayer = 0;
  bool _showDong = true;
  bool _showNiHaixia = true;
  bool _showTraditional = true;

  final List<String> _bodyLayers = ['全部', '骨骼', '肌肉', '經絡'];
  final List<String> _regions = [
    'all', 'head', 'face', 'neck', 'chest', 'back',
    'abdomen', 'arm', 'hand', 'leg', 'foot',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AcupunctureProvider>();
      provider.loadDongPoints();
      provider.loadNiHaixiaPoints();
    });
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
        title: const Text('3D針灸穴位圖'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: '智能辨證配針',
            onPressed: () => Navigator.pushNamed(context, '/acupuncture/intelligent'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: '篩選',
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '傳統經穴'),
            Tab(text: '董氏奇穴'),
            Tab(text: '倪師特效穴'),
          ],
          onTap: (index) {
            setState(() {
              _currentSystem = ['traditional', 'dong', 'nihaixia'][index];
            });
          },
        ),
      ),
      body: Column(
        children: [
          _buildBodyModelSection(),
          _buildLayerSelector(),
          _buildSearchBar(),
          Expanded(child: _buildAcupointList()),
        ],
      ),
    );
  }

  Widget _buildBodyModelSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _build3DModelPlaceholder(),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: _buildQuickRegionSelect(),
          ),
        ],
      ),
    );
  }

  Widget _build3DModelPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.accessibility_new, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  '3D人體模型',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  '（需Unity/WebGL支持）',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLayerIndicator('經絡', _bodyLayer == 0, Colors.blue),
                  const SizedBox(width: 4),
                  _buildLayerIndicator('肌肉', _bodyLayer == 1, Colors.red),
                  const SizedBox(width: 4),
                  _buildLayerIndicator('骨骼', _bodyLayer == 2, Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayerIndicator(String label, bool isActive, Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildQuickRegionSelect() {
    return Column(
      children: [
        const Text(
          '快速選擇部位',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.count(
            crossAxisCount: 5,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
            children: _regions.where((r) => r != 'all').map((region) {
              return _buildRegionButton(region);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionButton(String region) {
    final isSelected = _currentRegion == region;
    final regionNames = {
      'head': '頭',
      'face': '面',
      'neck': '頸',
      'chest': '胸',
      'back': '背',
      'abdomen': '腹',
      'arm': '臂',
      'hand': '手',
      'leg': '腿',
      'foot': '足',
    };
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentRegion = region;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            regionNames[region] ?? region,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLayerSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('顯示層次：', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _bodyLayers.length,
              itemBuilder: (context, index) {
                final isSelected = _bodyLayer == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_bodyLayers[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _bodyLayer = index;
                        });
                      }
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜尋穴位名稱或主治...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildAcupointList() {
    return Consumer<AcupunctureProvider>(
      builder: (context, provider, _) {
        List<Widget> points = [];

        if (_currentSystem == 'traditional') {
          points = provider.traditionalPoints
              .where((p) => _matchesFilter(p))
              .map((p) => _buildTraditionalPointTile(p))
              .toList();
        } else if (_currentSystem == 'dong' && _showDong) {
          points = provider.dongPoints
              .where((p) => _matchesDongFilter(p))
              .map((p) => _buildDongPointTile(p))
              .toList();
        } else if (_currentSystem == 'nihaixia' && _showNiHaixia) {
          points = provider.niHaixiaPoints
              .where((p) => _matchesNiHaixiaFilter(p))
              .map((p) => _buildNiHaixiaPointTile(p))
              .toList();
        }

        if (points.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  '未找到匹配的穴位',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView(children: points);
      },
    );
  }

  bool _matchesFilter(Acupoint point) {
    if (_currentRegion != 'all' && !point.meridian.toLowerCase().contains(_currentRegion)) {
      return false;
    }
    if (_searchQuery.isNotEmpty) {
      return point.name.contains(_searchQuery) ||
          point.indication.contains(_searchQuery);
    }
    return true;
  }

  bool _matchesDongFilter(DongAcupoint point) {
    if (_currentRegion != 'all' && point.mainRegion.name.toLowerCase() != _currentRegion) {
      return false;
    }
    if (_searchQuery.isNotEmpty) {
      return point.name.contains(_searchQuery) ||
          point.indication.contains(_searchQuery) ||
          point.namePinyin.toLowerCase().contains(_searchQuery.toLowerCase());
    }
    return true;
  }

  bool _matchesNiHaixiaFilter(NiHaixiaAcupoint point) {
    if (_currentRegion != 'all' && point.bodyRegion.name.toLowerCase() != _currentRegion) {
      return false;
    }
    if (_searchQuery.isNotEmpty) {
      return point.name.contains(_searchQuery) ||
          point.indication.contains(_searchQuery) ||
          point.namePinyin.toLowerCase().contains(_searchQuery.toLowerCase());
    }
    return true;
  }

  Widget _buildTraditionalPointTile(Acupoint point) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Text(point.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(point.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.meridian, style: const TextStyle(fontSize: 12)),
            Text(point.indication, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showTraditionalPointDetail(point),
      ),
    );
  }

  Widget _buildDongPointTile(DongAcupoint point) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.green.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(point.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
        ),
        title: Row(
          children: [
            Text(point.name),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('董氏', style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.namePinyin, style: const TextStyle(fontSize: 12)),
            Text(point.indication, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showDongPointDetail(point),
      ),
    );
  }

  Widget _buildNiHaixiaPointTile(NiHaixiaAcupoint point) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.purple.shade50,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Text(point.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
        ),
        title: Row(
          children: [
            Text(point.name),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('倪師', style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.namePinyin, style: const TextStyle(fontSize: 12)),
            Text(point.indication, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showNiHaixiaPointDetail(point),
      ),
    );
  }

  void _showTraditionalPointDetail(Acupoint point) {
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
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(point.name, style: const TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Text(point.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              Center(child: Text(point.meridian, style: TextStyle(color: Colors.grey.shade600))),
              const Divider(height: 32),
              _buildDetailSection('定位', point.location),
              _buildDetailSection('主治', point.indication),
              _buildDetailSection('技法', point.technique),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDongPointDetail(DongAcupoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Text(point.name, style: const TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(point.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('董氏奇穴'),
                    ),
                  ],
                ),
              ),
              Center(child: Text('${point.namePinyin} | ${point.nameEn}')),
              const Divider(height: 32),
              _buildDetailSection('部位所屬', point.region),
              _buildDetailSection('標準定位', point.location),
              _buildDetailSection('取穴方法', point.locationDescription),
              _buildDetailSection('主治範圍', point.indication),
              _buildDetailSection('進針角度', point.needleAngle),
              _buildDetailSection('進針深度', point.needleDepth),
              _buildDetailSection('操作手法', point.manipulation),
              _buildDetailSection('捻針補瀉', point.reinforcementReduction),
              _buildDetailSection('針感', point.qiArrival),
              _buildDetailSection('臨床應用', point.clinicalApplication),
              _buildDetailSection('倪師見解', point.mingLiConnection),
              if (point.sourceReferences.isNotEmpty)
                _buildDetailSection('來源參考', point.sourceReferences.join('、')),
              if (point.notes.isNotEmpty)
                _buildDetailSection('注意事項', point.notes, isWarning: true),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showNiHaixiaPointDetail(NiHaixiaAcupoint point) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.purple,
                  child: Text(point.name, style: const TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(point.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('倪海厦特效穴'),
                    ),
                  ],
                ),
              ),
              Center(child: Text('${point.namePinyin} | ${point.nameEn}')),
              const Divider(height: 32),
              _buildDetailSection('標準穴名', point.standardName),
              _buildDetailSection('部位', point.region),
              _buildDetailSection('標準定位', point.location),
              _buildDetailSection('取穴方法', point.locationMethod),
              _buildDetailSection('主治範圍', point.indication),
              _buildDetailSection('症狀特徵', point.symptomPattern),
              _buildDetailSection('進針深度', point.needleDepth),
              _buildDetailSection('進針角度', point.needleAngle),
              _buildDetailSection('操作手法', point.manipulation),
              _buildDetailSection('針感', point.needleResponse),
              _buildDetailSection('臨床備註', point.clinicalNote),
              _buildDetailSection('倪師心得', point.niHaixiaInsight),
              _buildDetailSection('經典參考', point.classicalReference),
              _buildDetailSection('配伍組合', point.combination),
              if (point.contraindication.isNotEmpty)
                _buildDetailSection('禁忌注意', point.contraindication, isWarning: true),
              if (point.diseaseFormulas.isNotEmpty)
                _buildDetailSection('疾病配方針', point.diseaseFormulas.join('、')),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isWarning ? Icons.warning : Icons.label,
                size: 18,
                color: isWarning ? Colors.orange : AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isWarning ? Colors.orange : AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isWarning ? Colors.orange.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('篩選設置'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('顯示穴位體系', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('傳統經穴'),
                value: _showTraditional,
                onChanged: (v) => setDialogState(() => _showTraditional = v ?? true),
                activeColor: AppTheme.primaryColor,
              ),
              CheckboxListTile(
                title: const Text('董氏奇穴'),
                value: _showDong,
                onChanged: (v) => setDialogState(() => _showDong = v ?? true),
                activeColor: Colors.green,
              ),
              CheckboxListTile(
                title: const Text('倪海厦特效穴'),
                value: _showNiHaixia,
                onChanged: (v) => setDialogState(() => _showNiHaixia = v ?? true),
                activeColor: Colors.purple,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}
