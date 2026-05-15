import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../providers/user_provider.dart';
import '../services/language_service.dart';
import '../services/verification_service.dart';
import '../services/eink_theme_service.dart';
import '../widgets/disclaimer_dialog.dart';

class EnhancedSettingsScreen extends StatefulWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  State<EnhancedSettingsScreen> createState() => _EnhancedSettingsScreenState();
}

class _EnhancedSettingsScreenState extends State<EnhancedSettingsScreen> {
  final LanguageProvider _languageProvider = LanguageProvider();
  final VerificationService _verificationService = VerificationService();
  final EInkThemeService _einkService = EInkThemeService();

  @override
  void initState() {
    super.initState();
    _languageProvider.init();
    _einkService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          return ListView(
            children: [
              _buildPlatformInfo(),
              const Divider(),
              _buildLanguageSection(),
              const Divider(),
              _buildDisplaySection(),
              const Divider(),
              _buildVerificationSection(context, user),
              const Divider(),
              _buildSecuritySection(context, user),
              const Divider(),
              _buildAboutSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlatformInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '靈',
                    style: TextStyle(
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
                      AppConstants.appName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppConstants.platformSlogan,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoChip(Icons.location_on, '運營主體', AppConstants.platformEntity),
          const SizedBox(height: 8),
          _buildInfoChip(Icons.dns, '伺服器', AppConstants.platformLocation),
          const SizedBox(height: 8),
          _buildInfoChip(Icons.storage, '數據存儲', '香港雲端伺服器'),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.language, color: Colors.blue),
      ),
      title: const Text('語言設置'),
      subtitle: Text(LanguageProvider.getLanguageName(_languageProvider.currentLanguageTag)),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showLanguageDialog,
    );
  }

  Widget _buildDisplaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.menu_book, color: Colors.brown),
              SizedBox(width: 8),
              Text(
                '顯示設置',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(
            _einkService.getModeIcon(),
            color: _einkService.isEInkMode ? Colors.brown : Colors.grey,
          ),
          title: const Text('護眼模式'),
          subtitle: Text(_einkService.getModeDisplayName()),
          trailing: _einkService.isEInkMode
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '墨水屏',
                    style: TextStyle(fontSize: 10, color: Colors.brown),
                  ),
                )
              : const Text('普通', style: TextStyle(color: Colors.grey)),
          onTap: _showEInkModeDialog,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.brown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '墨水屏模式採用暖色調設計，降低藍光，適合長時間學習閱讀',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEInkModeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.menu_book, color: Colors.brown),
            SizedBox(width: 8),
            Text('護眼模式'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                '選擇適合您的顯示模式，降低長時間學習的視覺疲勞',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            _buildEInkModeOption(
              '普通模式',
              '標準顯示效果',
              Icons.brightness_6,
              AppThemeMode.normal,
            ),
            const SizedBox(height: 8),
            _buildEInkModeOption(
              '墨水屏·護眼',
              '暖色調背景，降低藍光，護眼舒適',
              Icons.menu_book,
              AppThemeMode.einkLight,
            ),
            const SizedBox(height: 8),
            _buildEInkModeOption(
              '墨水屏·深色',
              '深色背景，省電護眼，適合暗光環境',
              Icons.brightness_2,
              AppThemeMode.einkDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEInkModeOption(
    String title,
    String subtitle,
    IconData icon,
    AppThemeMode mode,
  ) {
    final isSelected = _einkService.currentMode == mode;

    return InkWell(
      onTap: () {
        _einkService.setThemeMode(mode);
        Navigator.pop(context);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.brown.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.brown : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.brown : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.brown : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.brown),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationSection(BuildContext context, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                '身份認證',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getVerificationColor(user?.verificationLevel ?? 0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user?.verificationStatus ?? '未認證',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildVerificationTile(
          icon: Icons.phone_android,
          title: '手機認證',
          subtitle: user?.phoneVerified == true ? '已綁定 ${user?.phone}' : '未認證',
          isVerified: user?.phoneVerified ?? false,
          onTap: () => _showPhoneVerificationDialog(context),
        ),
        _buildVerificationTile(
          icon: Icons.email,
          title: '郵箱認證',
          subtitle: user?.emailVerified == true ? '已綁定 ${user?.email}' : '未認證',
          isVerified: user?.emailVerified ?? false,
          onTap: () => _showEmailVerificationDialog(context),
        ),
        _buildVerificationTile(
          icon: Icons.face,
          title: '人臉認證',
          subtitle: user?.faceVerified == true ? '已開通' : '可選認證',
          isVerified: user?.faceVerified ?? false,
          isOptional: true,
          onTap: () => _showFaceVerificationDialog(context),
        ),
      ],
    );
  }

  Widget _buildVerificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isVerified,
    bool isOptional = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isVerified ? Colors.green : Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isVerified
          ? const Icon(Icons.check_circle, color: Colors.green)
          : isOptional
              ? const Text('可選', style: TextStyle(color: Colors.grey))
              : const Icon(Icons.chevron_right),
      onTap: isVerified ? null : onTap,
    );
  }

  Color _getVerificationColor(int level) {
    switch (level) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSecuritySection(BuildContext context, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.security, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                '安全設置',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.lock),
          title: const Text('更改密碼'),
          subtitle: const Text('需要驗證後才能更改'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showChangePasswordDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                '關於平台',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: const Text('平台聲明'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showDisclaimerDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('支付說明'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPaymentDisclaimer(context),
        ),
        ListTile(
          leading: const Icon(Icons.campaign),
          title: const Text('推廣說明'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPromotionDisclaimer(context),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('版本 ${AppConstants.appVersion}'),
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選擇語言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageProvider.getSupportedLanguages().map((lang) {
            final isSelected = _languageProvider.currentLanguageTag == lang['tag'];
            return ListTile(
              title: Text(lang['name']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                _languageProvider.setLanguage(lang['tag']!);
                Navigator.pop(context);
                setState(() {});
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPhoneVerificationDialog(BuildContext context) {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();
    String? verificationCode;
    bool codeSent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('手機認證'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!codeSent) ...[
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '輸入手機號',
                    hintText: '請輸入手機號',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final success = await _verificationService.sendVerificationCode(
                      identifier: phoneController.text,
                      type: VerificationType.phone,
                    );
                    if (success.success) {
                      verificationCode = success.verificationCode;
                      setDialogState(() => codeSent = true);
                    }
                  },
                  child: const Text('發送驗證碼'),
                ),
              ] else ...[
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: '輸入驗證碼',
                    hintText: '請輸入6位驗證碼',
                  ),
                ),
                const SizedBox(height: 8),
                if (verificationCode != null)
                  Text(
                    '測試驗證碼: $verificationCode',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _verificationService.verifyCode(
                      identifier: phoneController.text,
                      type: VerificationType.phone,
                      code: codeController.text,
                    );
                    if (result.success) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('手機認證成功')),
                        );
                        setState(() {});
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }
                  },
                  child: const Text('驗證'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEmailVerificationDialog(BuildContext context) {
    final emailController = TextEditingController();
    final codeController = TextEditingController();
    String? verificationCode;
    bool codeSent = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('郵箱認證'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!codeSent) ...[
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '輸入郵箱',
                    hintText: '請輸入郵箱地址',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final success = await _verificationService.sendVerificationCode(
                      identifier: emailController.text,
                      type: VerificationType.email,
                    );
                    if (success.success) {
                      verificationCode = success.verificationCode;
                      setDialogState(() => codeSent = true);
                    }
                  },
                  child: const Text('發送驗證碼'),
                ),
              ] else ...[
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: '輸入驗證碼',
                    hintText: '請輸入6位驗證碼',
                  ),
                ),
                const SizedBox(height: 8),
                if (verificationCode != null)
                  Text(
                    '測試驗證碼: $verificationCode',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await _verificationService.verifyCode(
                      identifier: emailController.text,
                      type: VerificationType.email,
                      code: codeController.text,
                    );
                    if (result.success) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('郵箱認證成功')),
                        );
                        setState(() {});
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }
                  },
                  child: const Text('驗證'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFaceVerificationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('人臉認證'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.face,
                size: 60,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '人臉認證為可選功能\n完成後可提升賬戶安全性',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final faceService = FaceVerificationService();
                final result = await faceService.verifyFace(
                  userId: context.read<UserProvider>().currentUser?.id ?? '',
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.message)),
                  );
                  if (result.success) {
                    setState(() {});
                  }
                }
              },
              child: const Text('開始人臉認證'),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final codeController = TextEditingController();

    final user = context.read<UserProvider>().currentUser;
    final hasVerification = user?.phoneVerified == true || user?.emailVerified == true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('更改密碼'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasVerification) ...[
                const Text('請選擇驗證方式'),
                const SizedBox(height: 16),
                if (user?.phoneVerified == true)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final success = await _verificationService.sendVerificationCode(
                        identifier: user!.phone,
                        type: VerificationType.phone,
                      );
                      if (success.success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('驗證碼: ${success.verificationCode}')),
                        );
                      }
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('發送到手機'),
                  ),
              ] else ...[
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '當前密碼',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '請先完成手機或郵箱驗證以更改密碼',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '新密碼',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '確認新密碼',
                ),
              ),
              if (hasVerification) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: '驗證碼',
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('兩次密碼不一致')),
                );
                return;
              }

              if (hasVerification) {
                final user = context.read<UserProvider>().currentUser;
                final phone = user?.phone ?? '';
                final success = await context.read<UserProvider>().verifyAndChangePassword(
                  newPassword: newPasswordController.text,
                  phone: phone,
                  code: codeController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? '密碼更改成功' : '驗證失敗'),
                    ),
                  );
                }
              }
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }

  void _showDisclaimerDialog(BuildContext context) async {
    await GlobalDisclaimerDialog.show(context);
  }

  void _showPaymentDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支付說明'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.paymentDescryption,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.settlementNote,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _showPromotionDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('推廣說明'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AffiliateConstants.commissionRules,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Text(
                '傭金比例：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('一級佣金: ${(AffiliateConstants.level1CommissionRate * 100).toInt()}%'),
              Text('二級佣金: ${(AffiliateConstants.level2CommissionRate * 100).toInt()}%'),
              const SizedBox(height: 8),
              Text(
                AffiliateConstants.legalDisclaimer,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}
