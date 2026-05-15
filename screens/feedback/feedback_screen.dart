import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/user_provider.dart';
import '../../models/feedback.dart' as model;
import '../../services/database_service.dart';
import '../../config/theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  String _feedbackType = 'suggestion';

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('问题反馈'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '反馈类型',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('功能建议'),
                          selected: _feedbackType == 'suggestion',
                          onSelected: (_) {
                            setState(() => _feedbackType = 'suggestion');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Bug反馈'),
                          selected: _feedbackType == 'bug',
                          onSelected: (_) {
                            setState(() => _feedbackType = 'bug');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('投诉建议'),
                          selected: _feedbackType == 'complaint',
                          onSelected: (_) {
                            setState(() => _feedbackType = 'complaint');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '反馈内容',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: '请详细描述您的问题或建议...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入反馈内容';
                        }
                        if (value.length < 10) {
                          return '内容太短，请详细描述';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '上传图片（选填）',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('选择图片功能')),
                        );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '点击添加图片',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('提交反馈', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 24),
            _buildFaqSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection() {
    return ExpansionTile(
      title: const Text('常见问题'),
      children: [
        _buildFaqItem(
          '如何升级会员？',
          '进入"我的-会员中心"，选择套餐进行升级。',
        ),
        _buildFaqItem(
          '如何联系客服？',
          '至尊会员可享受专属客服服务，其他会员可通过反馈提交问题。',
        ),
        _buildFaqItem(
          '积分如何交易？',
          '进入"灵积积分-交易市场"，选择挂单或买入。',
        ),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ListTile(
      title: Text(question),
      subtitle: Text(answer, style: const TextStyle(fontSize: 12)),
    );
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final user = context.read<UserProvider>().currentUser;
    if (user == null) return;

    final feedback = model.Feedback(
      id: const Uuid().v4(),
      userId: user.id,
      type: _feedbackType,
      content: _contentController.text,
      createdAt: DateTime.now(),
    );

    await DatabaseService().insertFeedback(feedback);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('反馈已提交，感谢您的建议'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
