import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/registration_payment.dart';
import '../../config/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _realNameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  final _cryptoWalletController = TextEditingController();

  bool _isLoading = false;
  bool _agreedToTerms = false;
  int _countdown = 0;
  IdentityType _identityType = IdentityType.domestic;
  String? _selectedCryptoNetwork;

  final List<String> _cryptoNetworks = ['TRC20', 'ERC20', 'BEP20', 'SOL'];

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _realNameController.dispose();
    _inviteCodeController.dispose();
    _cryptoWalletController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildIdentitySelector(),
              const SizedBox(height: 24),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildCodeField(),
              const SizedBox(height: 16),
              _buildRealNameField(),
              if (_identityType == IdentityType.overseas) ...[
                const SizedBox(height: 16),
                _buildCryptoFields(),
              ],
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 16),
              _buildInviteCodeField(),
              const SizedBox(height: 16),
              _buildTermsCheckbox(),
              const SizedBox(height: 24),
              _buildRegisterButton(),
              const SizedBox(height: 16),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '创建账号',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          '一个手机号只能注册一个账号',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildIdentitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('身份类型', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildIdentityCard(
                type: IdentityType.domestic,
                icon: '🇨🇳',
                title: '境内用户',
                subtitle: '使用微信、支付宝',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildIdentityCard(
                type: IdentityType.overseas,
                icon: '🌍',
                title: '境外用户',
                subtitle: '支持加密货币',
              ),
            ),
          ],
        ),
        if (_identityType == IdentityType.overseas) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '已开通加密货币支付，可上传区块链收款码用于C2C结算',
                    style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIdentityCard({
    required IdentityType type,
    required String icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _identityType == type;
    return GestureDetector(
      onTap: () => setState(() => _identityType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: '手机号码',
        hintText: '请输入手机号',
        prefixIcon: Icon(Icons.phone_android),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入手机号';
        if (value.length != 11) return '手机号格式不正确';
        return null;
      },
    );
  }

  Widget _buildCodeField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: '验证码',
              hintText: '请输入验证码',
              prefixIcon: Icon(Icons.message),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入验证码';
              if (value.length != 6) return '验证码为6位数字';
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: OutlinedButton(
            onPressed: _countdown > 0 ? null : _sendCode,
            child: Text(_countdown > 0 ? '${_countdown}s' : '获取验证码'),
          ),
        ),
      ],
    );
  }

  Widget _buildRealNameField() {
    return TextFormField(
      controller: _realNameController,
      decoration: const InputDecoration(
        labelText: '真实姓名',
        hintText: '请输入真实姓名（用于实名认证）',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入真实姓名';
        return null;
      },
    );
  }

  Widget _buildCryptoFields() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedCryptoNetwork,
          decoration: const InputDecoration(
            labelText: '区块链网络',
            prefixIcon: Icon(Icons.language),
            border: OutlineInputBorder(),
          ),
          items: _cryptoNetworks.map((network) {
            return DropdownMenuItem(value: network, child: Text(network));
          }).toList(),
          onChanged: (value) => setState(() => _selectedCryptoNetwork = value),
          validator: (value) {
            if (_identityType == IdentityType.overseas && value == null) {
              return '请选择区块链网络';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cryptoWalletController,
          decoration: const InputDecoration(
            labelText: '钱包地址',
            hintText: '请输入您的加密货币收款地址',
            prefixIcon: Icon(Icons.account_balance_wallet),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (_identityType == IdentityType.overseas && (value == null || value.isEmpty)) {
              return '请输入钱包地址';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: '登录密码',
        hintText: '请设置登录密码',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入密码';
        if (value.length < 6) return '密码至少6位';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: const InputDecoration(
        labelText: '确认密码',
        hintText: '请再次输入密码',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordController.text) return '两次密码不一致';
        return null;
      },
    );
  }

  Widget _buildInviteCodeField() {
    return TextFormField(
      controller: _inviteCodeController,
      decoration: const InputDecoration(
        labelText: '邀请码（选填）',
        hintText: '请输入邀请码',
        prefixIcon: Icon(Icons.card_giftcard),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  const TextSpan(text: '我已阅读并同意'),
                  TextSpan(
                    text: '《用户协议》',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                  const TextSpan(text: '和'),
                  TextSpan(
                    text: '《隐私政策》',
                    style: TextStyle(color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _agreedToTerms ? _register : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('立即注册', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('已有账号？', style: TextStyle(color: Colors.grey.shade600)),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('立即登录'),
          ),
        ],
      ),
    );
  }

  void _sendCode() async {
    if (_phoneController.text.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的手机号')),
      );
      return;
    }

    setState(() => _countdown = 60);
    for (int i = 60; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdown = i - 1);
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.read<UserProvider>().register(
        phone: _phoneController.text,
        password: _passwordController.text,
        realName: _realNameController.text,
        inviteCode: _inviteCodeController.text.isNotEmpty ? _inviteCodeController.text : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('注册成功！')),
      );
      Navigator.pop(context);
    }
  }
}
