import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tech_veda/config/ad_config.dart';

/// Loads and shows AdMob interstitials.
class AdMobService {
  AdMobService._();
  static final AdMobService instance = AdMobService._();

  final Completer<void> _initCompleter = Completer<void>();
  bool _initialized = false;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
  DateTime? _lastInterstitialShown;

  /// Cooldown for non-course actions (Ask AI, Developer profile).
  static const _navigationCooldown = Duration(seconds: 90);

  /// Max wait for an ad to load before opening course content.
  static const _courseAdLoadTimeout = Duration(seconds: 5);

  Future<void> get ready => _initCompleter.future;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!AdConfig.isSupported) {
      _initialized = true;
      if (!_initCompleter.isCompleted) _initCompleter.complete();
      return;
    }

    try {
      final status = await MobileAds.instance.initialize();
      if (kDebugMode) {
        debugPrint('[AdMob] Initialized: $status');
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(
            testDeviceIds: const [],
          ),
        );
      }
      _initialized = true;
      loadInterstitial();
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AdMob] Initialize failed: $e\n$st');
      }
    } finally {
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  void loadInterstitial() {
    if (!AdConfig.isSupported || !_initialized || _isLoadingInterstitial) {
      return;
    }

    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = ad;
          _isLoadingInterstitial = false;
          if (kDebugMode) debugPrint('[AdMob] Interstitial loaded');
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoadingInterstitial = false;
          debugPrint('[AdMob] Interstitial failed: ${error.message}');
        },
      ),
    );
  }

  /// Before opening a **course PDF** — shows every tap, no cooldown.
  Future<void> showCourseInterstitialThen(void Function() onComplete) async {
    if (!AdConfig.isSupported || !_initialized) {
      onComplete();
      return;
    }

    await ready;

    if (_interstitialAd == null) {
      loadInterstitial();
      await _waitForInterstitial(_courseAdLoadTimeout);
    }

    final ad = _interstitialAd;
    if (ad == null) {
      debugPrint('[AdMob] No interstitial ready; opening course without ad');
      loadInterstitial();
      onComplete();
      return;
    }

    _showAd(ad, onComplete, applyCooldown: false);
  }

  /// Other navigation (Ask AI, Developer) — respects cooldown to avoid spam.
  void showInterstitialThen(void Function() onComplete) {
    if (!AdConfig.isSupported || !_initialized) {
      onComplete();
      return;
    }

    final now = DateTime.now();
    if (_lastInterstitialShown != null &&
        now.difference(_lastInterstitialShown!) < _navigationCooldown) {
      onComplete();
      return;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitial();
      onComplete();
      return;
    }

    _showAd(ad, onComplete, applyCooldown: true);
  }

  Future<bool> _waitForInterstitial(Duration maxWait) async {
    final deadline = DateTime.now().add(maxWait);
    while (DateTime.now().isBefore(deadline)) {
      if (_interstitialAd != null) return true;
      await Future.delayed(const Duration(milliseconds: 150));
    }
    return _interstitialAd != null;
  }

  void _showAd(
    InterstitialAd ad,
    void Function() onComplete, {
    required bool applyCooldown,
  }) {
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        if (applyCooldown) {
          _lastInterstitialShown = DateTime.now();
        }
        loadInterstitial();
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('[AdMob] Interstitial show failed: ${error.message}');
        loadInterstitial();
        onComplete();
      },
    );

    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
