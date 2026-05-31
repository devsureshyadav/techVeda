import 'package:flutter/foundation.dart';

/// AdMob configuration for TechVeda.
abstract final class AdConfig {
  static const appId = 'ca-app-pub-6713635279268340~6940175415';

  static const productionInterstitial =
      'ca-app-pub-6713635279268340/4139741934';

  static const productionBanners = [
    'ca-app-pub-6713635279268340/1869332040', // banner_1
    'ca-app-pub-6713635279268340/1322006909', // banner_2
    'ca-app-pub-6713635279268340/3108741617', // banner_3
  ];

  // Google sample units — use in debug to avoid invalid traffic.
  static const _debugInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _debugBanner = 'ca-app-pub-3940256099942544/6300978111';

  static bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Test ads in debug/profile; production units in release.
  /// New AdMob units can take 24–48h to serve — use debug build to verify integration.
  static bool get useTestAds => !kReleaseMode;

  static String get interstitialUnitId =>
      useTestAds ? _debugInterstitial : productionInterstitial;

  static String bannerUnitId(int index) {
    if (useTestAds) return _debugBanner;
    return productionBanners[index % productionBanners.length];
  }
}
