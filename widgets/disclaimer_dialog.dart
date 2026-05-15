import 'package:flutter/material.dart';
import '../config/constants.dart';

class GlobalDisclaimerDialog extends StatefulWidget {
  final VoidCallback? onConfirmed;
  final bool isRequired;

  const GlobalDisclaimerDialog({
    super.key,
    this.onConfirmed,
    this.isRequired = true,
  });

  @override
  State<GlobalDisclaimerDialog> createState() => _GlobalDisclaimerDialogState();
}

class _GlobalDisclaimerDialogState extends State<GlobalDisclaimerDialog> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;

  bool get _allChecked => _isChecked1 && _isChecked2 && _isChecked3;

  static const String platformDisclaimer = '''
【靈積學堂 - 平台聲明】

本平台為中國傳統文化學術交流、國學命理科普、中醫古籍養生學習平台。

平台資質：
• 運營主體：靈積國際文化有限公司
• 註冊地點：香港
• 伺服器及數據存儲：香港雲端伺服器

郑重声明：
1. 所有內容僅作學習娛樂交流參考，不構成醫療及人生決策建議
2. 平台嚴格遵循香港相關法例運營
3. 用戶需自行承擔使用平台內容的風險
4. 有健康問題請前往正規醫院就診
5. 重大人生決策請諮詢相應專業人士

特別提示：
• 本平台定位為傳統文化學術交流，非醫療服務機構
• 所有命理、國學內容僅供學習參考，不代表任何確定性預測
• 身體不適請立即前往正規醫院就診，切勿延誤
''';

  static const String paymentDisclaimer = '''
【支付與結算聲明】

支付說明：
• 本平台支持微信支付、支付寶，由香港正規企業資質申請海外商戶通道
• 資金結算留存香港賬戶，不回流內地個人賬戶
• 會員充值、單次付費、達人服務交易均可正常使用

價格說明：
• 所有價格以港幣或人民幣標示，實際扣費以支付渠道為準
• 達人服務收費由達人自主設置，平台固定收取10%服務費
''';

  static const String promotionDisclaimer = '''
【推廣分佣聲明】

合規聲明：
• 本推廣體系嚴格遵循香港法例，採用合規二級分銷模式
• 零門檻免費註冊即可參與推廣，無需購買會員、無需繳費
• 僅按真實成交訂單計算佣金，無拉人頭獎勵、無層級人頭計酬
• 直推一級分成、間推二級分成，三級及以上不再額外分潤

傭金結算：
• 會員充值、達人服務成交、博客付費等所有訂單
• 自動給上級兩級結算收益，結算透明可查
''';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildDisclaimerSection(
                '平台聲明',
                Icons.business,
                Colors.blue,
                platformDisclaimer,
                _isChecked1,
                (v) => setState(() => _isChecked1 = v ?? false),
                '我已閱讀並理解平台聲明',
              ),
              const SizedBox(height: 12),
              _buildDisclaimerSection(
                '支付結算聲明',
                Icons.payment,
                Colors.green,
                paymentDisclaimer,
                _isChecked2,
                (v) => setState(() => _isChecked2 = v ?? false),
                '我已閱讀並理解支付說明',
              ),
              const SizedBox(height: 12),
              _buildDisclaimerSection(
                '推廣分佣聲明',
                Icons.campaign,
                Colors.orange,
                promotionDisclaimer,
                _isChecked3,
                (v) => setState(() => _isChecked3 = v ?? false),
                '我已閱讀並理解推廣規則',
              ),
              const SizedBox(height: 20),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.gavel,
              color: AppTheme.primaryColor,
              size: 36,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '歡迎使用靈積學堂',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppConstants.platformSlogan,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '運營主體：${AppConstants.platformEntity}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerSection(
    String title,
    IconData icon,
    Color color,
    String content,
    bool isChecked,
    ValueChanged<bool?> onChanged,
    String checkText,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => onChanged(!isChecked),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  Icon(
                    isChecked ? Icons.check_circle : Icons.circle_outlined,
                    color: isChecked ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (isChecked) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    activeColor: Colors.green,
                  ),
                  Expanded(
                    child: Text(
                      checkText,
                      style: const TextStyle(fontSize: 12),
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

  Widget _buildConfirmButton() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _allChecked ? Colors.green.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _allChecked ? Colors.green : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _allChecked,
                onChanged: _allChecked ? (_) {} : null,
                activeColor: Colors.green,
              ),
              Expanded(
                child: Text(
                  '我已閱讀並同意以上所有聲明，將內容僅作學習參考使用',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _allChecked ? Colors.green.shade700 : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _allChecked
                ? () {
                    Navigator.pop(context, true);
                    widget.onConfirmed?.call();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _allChecked ? AppTheme.primaryColor : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              _allChecked ? '確認進入平台' : '請閱讀並勾選全部聲明',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const GlobalDisclaimerDialog(),
    );
    return result ?? false;
  }
}

class DisclaimerDialog extends StatefulWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback? onConfirmed;
  final bool isRequired;

  const DisclaimerDialog({
    super.key,
    this.title = '免責聲明',
    this.content = '',
    this.confirmText = '我已閱讀並同意',
    this.onConfirmed,
    this.isRequired = true,
  });

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  bool _isChecked = false;

  static const String defaultFortuneDisclaimer = '''
【重要提示 - 命理測算免責聲明】

平台所有命理測算內容僅作中國傳統文化學習交流用途，基於八字、奇門遁甲、紫微斗數等傳統命理理論進行推演分析。

鄭重聲明：
1. 命理測算結果僅供參考娛樂，不代表任何確定性預測
2. 平台及測算師不對測算結果的準確性做任何保證
3. 用戶應理性看待測算內容，不應將其作為重大人生決策的唯一依據
4. 因依賴測算結果而產生的任何後果，平台不承擔任何責任
5. 平台保留對測算內容進行解釋和調整的權利

特別提示：
• 婚姻、事業、投資等重大決策請諮詢專業人士
• 測算結果受輸入信息準確性影響，僅供參考
• 傳統文化解讀存在主觀性，請保持理性判斷
''';

  static const String defaultTCMDisclaimer = '''
【重要提示 - 中醫經方免責聲明】

平台所有中醫經方內容僅作中醫藥傳統文化學習交流用途，基於《黃帝內經》《傷寒論》等中醫經典理論進行講解分析。

鄭重聲明：
1. 所有經方內容僅供學習參考，不構成任何醫療建議
2. 平台不對經方的療效做任何保證
3. 中醫診療請前往正規醫療機構就診
4. 因自行使用經方產生的任何後果，平台不承擔任何責任
5. 平台保留對經方內容進行解釋和調整的權利

特別提示：
• 身體不適請立即前往正規醫院就診
• 中藥使用需在專業中醫師指導下進行
• 孕期、哺乳期、過敏體質者更應謹慎
• 本平台不具備醫療服務資質
''';

  static const String defaultConsultationDisclaimer = '''
【重要提示 - 諮詢服務免責聲明】

平台所有諮詢服務內容僅作學習交流用途，不構成專業醫療、法律、金融等領域的服務承諾。

鄭重聲明：
1. 諮詢服務內容僅供參考，不構成專業意見
2. 平台及服務提供者不對諮詢結果的準確性做任何保證
3. 重大事項請諮詢相應領域的持證專業人士
4. 因依賴諮詢結果而產生的任何後果，平台不承擔任何責任
5. 平台保留對服務內容進行解釋和調整的權利

特別提示：
• 身體不適請前往正規醫院就診
• 法律問題請諮詢執業律師
• 投資理財請諮詢持牌金融機構
• 心理健康問題請尋求專業心理諮詢師幫助
''';

  @override
  Widget build(BuildContext context) {
    final displayContent = widget.content.isNotEmpty
        ? widget.content
        : defaultFortuneDisclaimer;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '使用前必讀',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      displayContent,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => setState(() => _isChecked = !_isChecked),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _isChecked ? Colors.green.shade50 : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isChecked ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) => setState(() => _isChecked = value ?? false),
                        activeColor: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '我已閱讀並理解上述免責聲明，僅將內容作為學習參考使用，身體不適時會前往正規醫院就診',
                          style: TextStyle(
                            fontSize: 13,
                            color: _isChecked ? Colors.green.shade700 : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (!widget.isRequired) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isChecked
                          ? () {
                              Navigator.pop(context, true);
                              widget.onConfirmed?.call();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isChecked ? Colors.green : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        _isChecked ? '確認進入' : '請勾選確認',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> showFortuneDisclaimer(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DisclaimerDialog(
        title: '命理測算聲明',
        content: defaultFortuneDisclaimer,
      ),
    );
    return result ?? false;
  }

  static Future<bool> showTCMDisclaimer(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DisclaimerDialog(
        title: '中醫經方聲明',
        content: defaultTCMDisclaimer,
      ),
    );
    return result ?? false;
  }

  static Future<bool> showConsultationDisclaimer(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DisclaimerDialog(
        title: '諮詢服務聲明',
        content: defaultConsultationDisclaimer,
      ),
    );
    return result ?? false;
  }
}

class RatingDialog extends StatefulWidget {
  final String serviceTitle;
  final int? initialRating;

  const RatingDialog({
    super.key,
    required this.serviceTitle,
    this.initialRating,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int _rating;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating ?? 0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '服務評價',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.serviceTitle,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              _getRatingText(),
              style: TextStyle(
                fontSize: 14,
                color: _getRatingColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '請輸入您的評價（選填）',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'rating': _rating,
                        'comment': _commentController.text,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('提交評價'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return '非常不滿意 ⭐';
      case 2:
        return '不滿意 ⭐⭐';
      case 3:
        return '一般 ⭐⭐⭐';
      case 4:
        return '滿意 ⭐⭐⭐⭐';
      case 5:
        return '非常滿意 ⭐⭐⭐⭐⭐';
      default:
        return '請選擇評分';
    }
  }

  Color _getRatingColor() {
    switch (_rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class ContentDisclaimerBanner extends StatelessWidget {
  final String text;

  const ContentDisclaimerBanner({
    super.key,
    this.text = '以上內容僅作學習交流用途，不構成醫療建議',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
