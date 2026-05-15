import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/tcm/prescription_screen.dart';
import '../screens/tcm/consultation_screen.dart';
import '../screens/tcm/tongue_screen.dart';
import '../screens/tcm/pulse_screen.dart';
import '../screens/acupuncture/acupoint_screen.dart';
import '../screens/acupuncture/ling_gui_ba_fa_screen.dart';
import '../screens/acupuncture/fei_teng_ba_fa_screen.dart';
import '../screens/acupuncture/zi_wu_liu_zhu_screen.dart';
import '../screens/fortune/fortune_screen.dart';
import '../screens/fortune/fortune_detail_screen.dart';
import '../screens/fortune/mingli_screen.dart';
import '../screens/fortune/fortune_card_screen.dart';
import '../screens/fortune/da_liu_ren_screen.dart';
import '../screens/fortune/liu_yao_screen.dart';
import '../screens/fortune/qi_men_dun_jia_screen.dart';
import '../screens/fortune/maitai_screen.dart';
import '../screens/fortune/digital_energy_screen.dart';
import '../screens/fortune/face_palm_screen.dart';
import '../screens/tools/tools_screen.dart';
import '../screens/wuyunliuqi/wuyun_screen.dart';
import '../screens/wuyunliuqi/enhanced_wuyun_screen.dart';
import '../screens/community/community_list_screen.dart';
import '../screens/community/chat_screen.dart';
import '../screens/lingji/lingji_screen.dart';
import '../screens/feedback/feedback_screen.dart';
import '../screens/feedback/enhanced_feedback_screen.dart';
import '../screens/community/social_screen.dart';
import '../screens/my/profile_screen.dart';
import '../screens/my/enhanced_profile_screen.dart';
import '../screens/my/member_screen.dart';
import '../screens/my/enhanced_member_screen.dart';
import '../screens/my/settings_screen.dart';
import '../screens/my/enhanced_settings_screen.dart';
import '../screens/promotion/promotion_center_screen.dart';
import '../screens/lingji/lingji_market_screen.dart';
import '../screens/tcm/ai_prescription_screen.dart';
import '../screens/tcm/ai_analysis_screen.dart';
import '../screens/tcm/herb_database_screen.dart';
import '../screens/tcm/comprehensive_diagnosis_screen.dart';
import '../screens/acupuncture/enhanced_acupuncture_screen.dart';
import '../screens/acupuncture/enhanced_3d_acupuncture_screen.dart';
import '../screens/acupuncture/intelligent_acupuncture_screen.dart';
import '../screens/acupuncture/bone_setting_massage_screen.dart';
import '../screens/home/newbie_guide_screen.dart';
import '../screens/books/book_reader_screen.dart';
import '../screens/store/store_screen.dart';
import '../screens/store/store_card_screen.dart';
import '../screens/admin/permission_center_screen.dart';
import '../screens/blog/blog_screen.dart';
import '../screens/talent/talent_showcase_screen.dart';
import '../screens/school/school_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/user/user_center_screen.dart';
import '../screens/auth/verification_center_screen.dart';
import '../screens/chat/private_chat_screen.dart';
import '../screens/chat/group_chat_screen.dart';
import '../config/theme.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final userProvider = context.read<UserProvider>();
    final isLoggedIn = userProvider.isLoggedIn;
    final isAuthRoute = state.matchedLocation == '/login' ||
                        state.matchedLocation == '/register' ||
                        state.matchedLocation == '/';

    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }
    if (isLoggedIn && isAuthRoute && state.matchedLocation != '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeContentScreen(),
          ),
          routes: [
            GoRoute(
              path: 'newbie',
              builder: (context, state) => const NewbieGuideScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/tcm',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TCMHomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'prescription',
              builder: (context, state) => const PrescriptionScreen(),
            ),
            GoRoute(
              path: 'ai-prescription',
              builder: (context, state) => const AIPrescriptionScreen(),
            ),
            GoRoute(
              path: 'consultation',
              builder: (context, state) => const ConsultationScreen(),
            ),
            GoRoute(
              path: 'tongue',
              builder: (context, state) => const TongueScreen(),
            ),
            GoRoute(
              path: 'pulse',
              builder: (context, state) => const PulseScreen(),
            ),
            GoRoute(
              path: 'herb-database',
              builder: (context, state) => const HerbDatabaseScreen(),
            ),
            GoRoute(
              path: 'comprehensive-diagnosis',
              builder: (context, state) => const ComprehensiveDiagnosisScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/acupuncture',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AcupunctureHomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'acupoints',
              builder: (context, state) => const AcupointScreen(),
            ),
            GoRoute(
              path: 'enhanced',
              builder: (context, state) => const EnhancedAcupunctureScreen(),
            ),
            GoRoute(
              path: '3d-model',
              builder: (context, state) => const Enhanced3DAcupunctureScreen(),
            ),
            GoRoute(
              path: 'bone-setting',
              builder: (context, state) => const BoneSettingMassageScreen(),
            ),
            GoRoute(
              path: 'intelligent',
              builder: (context, state) => const IntelligentAcupunctureScreen(),
            ),
            GoRoute(
              path: 'ling-gui',
              builder: (context, state) => const LingGuiBaFaScreen(),
            ),
            GoRoute(
              path: 'fei-teng',
              builder: (context, state) => const FeiTengBaFaScreen(),
            ),
            GoRoute(
              path: 'zi-wu',
              builder: (context, state) => const ZiWuLiuZhuScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/fortune',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FortuneCardScreen(),
          ),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) => const FortuneDetailScreen(),
            ),
            GoRoute(
              path: 'mingli',
              builder: (context, state) => const MingLiScreen(),
            ),
            GoRoute(
              path: 'da-liu-ren',
              builder: (context, state) => const DaLiuRenScreen(),
            ),
            GoRoute(
              path: 'liu-yao',
              builder: (context, state) => const LiuYaoScreen(),
            ),
            GoRoute(
              path: 'qi-men',
              builder: (context, state) => const QiMenDunJiaScreen(),
            ),
            GoRoute(
              path: 'maitai',
              builder: (context, state) => const MaitaiScreen(),
            ),
            GoRoute(
              path: 'digital-energy',
              builder: (context, state) => const DigitalEnergyScreen(),
            ),
            GoRoute(
              path: 'face-palm',
              builder: (context, state) => const FacePalmScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/tools',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ToolsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'compass',
              builder: (context, state) => const ToolsScreen(),
            ),
            GoRoute(
              path: 'lubanchi',
              builder: (context, state) => const ToolsScreen(),
            ),
            GoRoute(
              path: 'fengshui',
              builder: (context, state) => const ToolsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/school',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SchoolScreen(),
          ),
        ),
        GoRoute(
          path: '/wallet',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: WalletScreen(),
          ),
        ),
        GoRoute(
          path: '/wuyun',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: EnhancedWuYunScreen(),
          ),
        ),
        GoRoute(
          path: '/store',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: StoreScreen(),
          ),
        ),
        GoRoute(
          path: '/blog',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BlogScreen(),
          ),
        ),
        GoRoute(
          path: '/promotion',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PromotionCenterScreen(),
          ),
        ),
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CommunityListScreen(),
          ),
          routes: [
            GoRoute(
              path: 'chat',
              builder: (context, state) {
                final communityId = state.uri.queryParameters['id'] ?? '';
                return ChatScreen(communityId: communityId);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/lingji',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LingjiScreen(),
          ),
          routes: [
            GoRoute(
              path: 'market',
              builder: (context, state) => const LingjiMarketScreen(),
            ),
            GoRoute(
              path: 'wallet',
              builder: (context, state) => const LingjiScreen(),
            ),
            GoRoute(
              path: 'promotion',
              builder: (context, state) => const PromotionCenterScreen(),
            ),
            GoRoute(
              path: 'social',
              builder: (context, state) => const SocialScreen(),
            ),
            GoRoute(
              path: 'feedback',
              builder: (context, state) => const EnhancedFeedbackScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/my',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MyHomeScreen(),
          ),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const EnhancedProfileScreen(),
            ),
            GoRoute(
              path: 'member',
              builder: (context, state) => const EnhancedMemberScreen(),
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => const EnhancedSettingsScreen(),
            ),
            GoRoute(
              path: 'permission',
              builder: (context, state) => const PermissionCenterScreen(),
            ),
            GoRoute(
              path: 'talent/:id',
              builder: (context, state) {
                final talentId = state.pathParameters['id'] ?? '';
                return TalentShowcaseScreen(talentId: talentId);
              },
            ),
            GoRoute(
              path: 'affiliate',
              builder: (context, state) => const AffiliatePromotionScreen(),
            ),
            GoRoute(
              path: 'user-center',
              builder: (context, state) => const UserCenterScreen(),
            ),
            GoRoute(
              path: 'verification',
              builder: (context, state) => const VerificationCenterScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/chat',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SocialScreen(),
          ),
          routes: [
            GoRoute(
              path: 'private/:userId',
              builder: (context, state) {
                final userId = state.pathParameters['userId'] ?? '';
                return PrivateChatScreen(targetUserId: userId);
              },
            ),
            GoRoute(
              path: 'group/:groupId',
              builder: (context, state) {
                final groupId = state.pathParameters['groupId'] ?? '';
                return GroupChatScreen(groupId: groupId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/tcm')) return 1;
    if (location.startsWith('/fortune')) return 2;
    if (location.startsWith('/tools')) return 3;
    if (location.startsWith('/school')) return 4;
    if (location.startsWith('/store')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) {
            switch (index) {
              case 0:
                context.go('/home');
                break;
              case 1:
                context.go('/tcm');
                break;
              case 2:
                context.go('/fortune');
                break;
              case 3:
                context.go('/tools');
                break;
              case 4:
                context.go('/school');
                break;
              case 5:
                context.go('/store');
                break;
            }
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_hospital_outlined),
              selectedIcon: Icon(Icons.local_hospital),
              label: '中医',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: '易学',
            ),
            NavigationDestination(
              icon: Icon(Icons.build_outlined),
              selectedIcon: Icon(Icons.build),
              label: '工具',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: '学堂',
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store),
              label: '商城',
            ),
          ],
      ),
    );
  }
}

class TCMHomeScreen extends StatelessWidget {
  const TCMHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('中医经方'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeatureCard(
            context,
            'AI智能开方',
            '倪海厦标准教学解析',
            Icons.auto_awesome,
            () => context.go('/tcm/ai-prescription'),
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '经方库',
            '十大名家经典方剂',
            Icons.menu_book,
            () => context.go('/tcm/prescription'),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '药材数据库',
            '20味核心药材详解',
            Icons.spa,
            () => context.go('/tcm/herb-database'),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '全身问诊',
            '症状+舌诊+脉诊综合辨证',
            Icons.medical_services,
            () => context.go('/tcm/comprehensive-diagnosis'),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '舌象分析',
            '智能舌诊，辨别舌色苔色',
            Icons.face,
            () => context.go('/tcm/tongue'),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '脉象分析',
            '28种脉象辨证论治',
            Icons.favorite,
            () => context.go('/tcm/pulse'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String desc, IconData icon, VoidCallback onTap, {Color? color}) {
    final cardColor = color ?? AppTheme.primaryColor;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cardColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(desc),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class AcupunctureHomeScreen extends StatelessWidget {
  const AcupunctureHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('针灸穴位'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.accessibility_new,
                    size: 80,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '超高清3D针灸穴位图',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '全身14经络361穴位 · 分层显示 · 动态演示',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/acupuncture/3d-model'),
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text('进入3D模型'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '正骨推拿专区',
            '柔性正骨、美式正骨、龙氏正骨等流派详解',
            Icons.self_improvement,
            () => context.go('/acupuncture/bone-setting'),
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            'AI智能配穴',
            '按病症自动推荐穴位',
            Icons.auto_awesome,
            () => context.go('/acupuncture/enhanced'),
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '古籍流派',
            '黄帝内经、董氏奇穴等',
            Icons.menu_book,
            () => context.go('/acupuncture/enhanced'),
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            context,
            '子午流注',
            '灵龟八法、飞腾八法',
            Icons.schedule,
            () => context.go('/acupuncture/enhanced'),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String desc, IconData icon, VoidCallback onTap, {Color? color}) {
    final cardColor = color ?? AppTheme.primaryColor;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: cardColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: InkWell(
                  onTap: () => context.go('/my/profile'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            user?.nickname.substring(0, 1) ?? '游',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.nickname ?? '未登录',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '手机号: ${user?.phone.replaceRange(3, 7, '****') ?? ''}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: InkWell(
                  onTap: () => context.go('/my/member'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.workspace_premium, color: Colors.amber),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '会员: ${_getMemberName(user?.memberLevel ?? 0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                user?.memberLevel == 0 ? '升级解锁云备份' : '畅享全部功能',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('权限配置中心'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/my/permission'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.feedback),
                      title: const Text('问题反馈'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/my/feedback'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('设置'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/my/settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('退出登录', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('退出登录'),
                        content: const Text('确定要退出登录吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('取消'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: const Text('退出'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await context.read<UserProvider>().logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getMemberName(int level) {
    switch (level) {
      case 0:
        return '免费会员';
      case 1:
        return '初级会员';
      case 2:
        return '中级会员';
      case 3:
        return '高级会员';
      case 4:
        return '至尊会员';
      case 5:
        return '金牌会员';
      default:
        return '免费会员';
    }
  }
}
