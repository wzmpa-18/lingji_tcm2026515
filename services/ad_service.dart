import 'package:flutter/material.dart';

enum AdPosition {
  splash,
  banner,
  interstitial,
  native,
}

enum AdType {
  banner,
  interstitial,
  rewarded,
}

class AdConfig {
  final String adUnitId;
  final AdPosition position;
  final bool isEnabled;
  final int refreshInterval;
  final List<int>? showAfterVersion;
  final bool memberOnly;

  const AdConfig({
    required this.adUnitId,
    required this.position,
    this.isEnabled = true,
    this.refreshInterval = 60,
    this.showAfterVersion,
    this.memberOnly = false,
  });
}

class AdService with ChangeNotifier {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  bool _splashAdShown = false;
  DateTime? _lastAdTime;

  static const Map<AdPosition, AdConfig> _adConfigs = {
    AdPosition.splash: AdConfig(
      adUnitId: 'ca-app-pub-xxxxx/splash',
      position: AdPosition.splash,
      refreshInterval: 0,
    ),
    AdPosition.banner: AdConfig(
      adUnitId: 'ca-app-pub-xxxxx/banner',
      position: AdPosition.banner,
      refreshInterval: 60,
    ),
    AdPosition.interstitial: AdConfig(
      adUnitId: 'ca-app-pub-xxxxx/interstitial',
      position: AdPosition.interstitial,
      refreshInterval: 180,
    ),
  };

  bool get isInitialized => _isInitialized;
  bool get splashAdShown => _splashAdShown;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    notifyListeners();
  }

  bool shouldHideAds(int? memberLevel) {
    if (memberLevel == null) return false;
    return memberLevel >= 1;
  }

  bool shouldShowBanner(int? memberLevel) {
    if (memberLevel != null && memberLevel >= 1) return false;
    return true;
  }

  bool shouldShowSplashAd() {
    if (_splashAdShown) return false;
    return true;
  }

  bool shouldShowInterstitial() {
    if (_lastAdTime != null) {
      final elapsed = DateTime.now().difference(_lastAdTime!).inSeconds;
      if (elapsed < 180) return false;
    }
    return true;
  }

  Future<void> showSplashAd(BuildContext context) async {
    if (!shouldShowSplashAd()) return;
    
    _splashAdShown = true;
    
    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (context) => _SplashAdWidget(
        onDismiss: () {
          Navigator.pop(context);
          _lastAdTime = DateTime.now();
        },
      ),
    );
  }

  Future<void> showInterstitialAd(BuildContext context) async {
    if (!shouldShowInterstitial()) return;
    
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _InterstitialAdWidget(
        onDismiss: () {
          Navigator.pop(context);
          _lastAdTime = DateTime.now();
        },
      ),
    );
  }

  String getAdUnitId(AdPosition position) {
    return _adConfigs[position]?.adUnitId ?? '';
  }

  Widget buildBannerAd() {
    return Container(
      height: 50,
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '广告位',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'X',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashAdWidget extends StatelessWidget {
  final VoidCallback onDismiss;

  const _SplashAdWidget({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onDismiss,
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 250,
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 48, color: Colors.white54),
                          SizedBox(height: 8),
                          Text(
                            '全屏视频广告位',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '点击跳过',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: TextButton(
            onPressed: onDismiss,
            child: const Text(
              '跳过',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '付费会员可关闭广告',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _InterstitialAdWidget extends StatelessWidget {
  final VoidCallback onDismiss;

  const _InterstitialAdWidget({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '广告',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '付费会员可关闭',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.white54),
                      SizedBox(height: 8),
                      Text(
                        '插屏广告位',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('关闭广告'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdBannerWidget extends StatelessWidget {
  final int? memberLevel;

  const AdBannerWidget({super.key, this.memberLevel});

  @override
  Widget build(BuildContext context) {
    final adService = AdService();
    
    if (!adService.shouldShowBanner(memberLevel)) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '广告位',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showUpgradeTip(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                '升级去广告',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpgradeTip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 48,
              color: Color(0xFFFFD700),
            ),
            const SizedBox(height: 16),
            const Text(
              '升级会员',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '成为付费会员，享受无广告体验',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('立即升级'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('稍后再说'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdServiceProvider {
  static Widget wrapWithAdBanner(BuildContext context, Widget child, int? memberLevel) {
    return Column(
      children: [
        Expanded(child: child),
        AdBannerWidget(memberLevel: memberLevel),
      ],
    );
  }
}
