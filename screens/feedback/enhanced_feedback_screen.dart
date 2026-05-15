import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/feedback_submission.dart';
import '../../models/user_badge.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class EnhancedFeedbackScreen extends StatefulWidget {
  const EnhancedFeedbackScreen({super.key});

  @override
  State<EnhancedFeedbackScreen> createState() => _EnhancedFeedbackScreenState();
}

class _EnhancedFeedbackScreenState extends State<EnhancedFeedbackScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  FeedbackCategory _selectedCategory = FeedbackCategory.other;
  final List<String> _images = [];
  bool _isSubmitting = false;
  List<FeedbackSubmission> _mySubmissions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('问题反馈'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '提交反馈'),
            Tab(text: '我的反馈'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSubmitTab(),
          _buildMyFeedbackTab(),
        ],
      ),
    );
  }

  Widget _buildSubmitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySelector(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildContentField(),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 32),
            _buildCoBuildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('问题分类', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FeedbackCategory.values.map((cat) {
            final isSelected = _selectedCategory == cat;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat.icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
                  const SizedBox(width: 4),
                  Text(cat.displayName),
                ],
              ),
              selected: isSelected,
              selectedColor: AppTheme.primaryColor,
              onSelected: (_) => setState(() => _selectedCategory = cat),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(_selectedCategory.description, style: const TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: '问题标题',
        hintText: '请简要描述问题',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入问题标题';
        if (value.length < 5) return '标题至少5个字符';
        return null;
      },
    );
  }

  Widget _buildContentField() {
    return TextFormField(
      controller: _contentController,
      maxLines: 6,
      decoration: const InputDecoration(
        labelText: '详细描述',
        hintText: '请详细描述问题，包括：\n1. 问题现象\n2. 操作步骤\n3. 期望结果\n4. 实际结果',
        alignLabelWithHint: true,
        prefixIcon: Padding(padding: EdgeInsets.only(bottom: 80)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入详细描述';
        if (value.length < 20) return '描述至少20个字符';
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('上传截图（可选）', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._images.map((path) => _buildImagePreview(path)),
            if (_images.length < 5)
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('添加图片', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text('最多上传5张图片，支持PNG、JPG格式', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildImagePreview(String path) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
            onPressed: () => setState(() => _images.remove(path)),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _images.add(image.path));
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitFeedback,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text('提交反馈'),
      ),
    );
  }

  Widget _buildCoBuildInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.teal.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.handshake, color: Colors.green),
              SizedBox(width: 8),
              Text('民间专业共建', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '开放中医、命理、技术爱好者提交纠错、校对、优化建议。\n\n'
            '• 有效BUG奖励50灵积\n'
            '• 校正专业内容被采纳奖励100灵积\n'
            '• 优质建议被采纳奖励200灵积',
            style: const TextStyle(fontSize: 13, height: 1.6),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '恶意乱发错误内容、篡改专业知识、误导用户，将扣除灵积、取消共建资格、限制功能甚至封号',
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyFeedbackTab() {
    if (_mySubmissions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无反馈记录', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mySubmissions.length,
      itemBuilder: (context, index) {
        final submission = _mySubmissions[index];
        return _buildFeedbackCard(submission);
      },
    );
  }

  Widget _buildFeedbackCard(FeedbackSubmission submission) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: submission.category.icon == Icons.bug_report ? Colors.red.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(submission.category.icon, size: 14, color: Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(submission.category.displayName, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: submission.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    submission.status.displayName,
                    style: TextStyle(fontSize: 12, color: submission.status.color, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(submission.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(submission.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
            if (submission.officialReply != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        SizedBox(width: 4),
                        Text('官方回复', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(submission.officialReply!, style: const TextStyle(fontSize: 13)),
                    if (submission.lingjiReward != null && submission.lingjiReward! > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars, size: 14, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('+${submission.lingjiReward}灵积', style: const TextStyle(fontSize: 12, color: Colors.amber)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${submission.createdAt.year}-${submission.createdAt.month.toString().padLeft(2, '0')}-${submission.createdAt.day.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 1));

    final user = context.read<UserProvider>().currentUser;
    final submission = FeedbackSubmission(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      userId: user?.id ?? '',
      userName: user?.nickname ?? '匿名用户',
      category: _selectedCategory,
      title: _titleController.text,
      content: _contentController.text,
      images: _images,
      createdAt: DateTime.now(),
    );

    setState(() {
      _mySubmissions.insert(0, submission);
      _isSubmitting = false;
      _titleController.clear();
      _contentController.clear();
      _images.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('反馈已提交，我们会尽快处理！'),
          backgroundColor: Colors.green,
        ),
      );
      _tabController.animateTo(1);
    }
  }
}
