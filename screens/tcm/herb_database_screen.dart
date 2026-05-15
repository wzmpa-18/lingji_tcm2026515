import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/herb_service.dart';
import '../../models/herb.dart';
import '../../config/theme.dart';

class HerbDatabaseScreen extends StatefulWidget {
  const HerbDatabaseScreen({super.key});

  @override
  State<HerbDatabaseScreen> createState() => _HerbDatabaseScreenState();
}

class _HerbDatabaseScreenState extends State<HerbDatabaseScreen> {
  final HerbService _herbService = HerbService();
  final TextEditingController _searchController = TextEditingController();
  List<Herb> _herbs = [];
  List<Herb> _filteredHerbs = [];

  @override
  void initState() {
    super.initState();
    _loadHerbs();
  }

  void _loadHerbs() {
    _herbService.initHerbs();
    setState(() {
      _herbs = _herbService.getAllHerbs();
      _filteredHerbs = _herbs;
    });
  }

  void _searchHerbs(String query) {
    setState(() {
      _filteredHerbs = _herbService.searchHerbs(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('药材数据库'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索药材名称、功效...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchHerbs('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchHerbs,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '共 ${_filteredHerbs.length} 味药材',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredHerbs.length,
              itemBuilder: (context, index) {
                return _buildHerbCard(_filteredHerbs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHerbCard(Herb herb) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showHerbDetail(herb),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    herb.name.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
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
                          herb.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          herb.pinyin,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTag('性', herb.nature),
                        const SizedBox(width: 8),
                        _buildTag('味', herb.taste),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      herb.effect,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
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

  Widget _buildTag(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label:$value',
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  void _showHerbDetail(Herb herb) {
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
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          herb.name.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            herb.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          Text(
                            herb.pinyin,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            herb.latinName,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailSection('药性', '${herb.nature}性，${herb.taste}味'),
                _buildDetailSection('归经', herb.meridian),
                _buildDetailSection('功效', herb.effect),
                _buildDetailSection('主治', herb.indication),
                if (herb.preparation.isNotEmpty)
                  _buildDetailSection('炮制方法', herb.preparation),
                _buildDetailSection('常用剂量', herb.dosage),
                if (herb.usage.isNotEmpty)
                  _buildDetailSection('用法', herb.usage),
                if (herb.contraindication.isNotEmpty)
                  _buildDetailSection('配伍禁忌', herb.contraindication, isWarning: true),
                if (herb.famousUse.isNotEmpty)
                  _buildDetailSection('倪海厦用药心得', herb.famousUse, isHighlight: true),
                if (herb.specialFunction.isNotEmpty)
                  _buildDetailSection('专属作用', herb.specialFunction),
                if (herb.inFormulaFunctions != null && herb.inFormulaFunctions!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    '在不同方剂中的专属功用',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...herb.inFormulaFunctions!.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(e.value),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, {bool isWarning = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : AppTheme.secondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isWarning 
                  ? Colors.red.withOpacity(0.1)
                  : isHighlight 
                      ? AppTheme.accentColor.withOpacity(0.1)
                      : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isWarning ? Colors.red.shade700 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
