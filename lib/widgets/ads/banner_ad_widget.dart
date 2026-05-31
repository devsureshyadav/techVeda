import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tech_veda/config/ad_config.dart';
import 'package:tech_veda/services/admob_service.dart';
import 'package:tech_veda/theme/app_theme.dart';

/// Adaptive-width banner for a specific ad unit [bannerIndex] (0–2).
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    super.key,
    required this.bannerIndex,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final int bannerIndex;
  final EdgeInsets margin;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  bool _loadFailed = false;
  AdSize? _adSize;
  int _retryCount = 0;
  static const _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _scheduleLoad();
  }

  void _scheduleLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadBanner());
  }

  Future<void> _loadBanner() async {
    if (!AdConfig.isSupported || _isLoading || !mounted) return;

    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });

    await AdMobService.instance.ready;
    if (!mounted) return;

    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;

    final width = MediaQuery.sizeOf(context).width.truncate();
    final adaptive =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    // Fallback when adaptive size is unavailable (some devices / emulators).
    final AdSize size = adaptive ?? AdSize.banner;

    final ad = BannerAd(
      adUnitId: AdConfig.bannerUnitId(widget.bannerIndex),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _isLoaded = true;
            _isLoading = false;
            _loadFailed = false;
            _adSize = size;
          });
          debugPrint('[AdMob] Banner ${widget.bannerIndex} loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint(
            '[AdMob] Banner ${widget.bannerIndex} failed '
            '(attempt ${_retryCount + 1}): ${error.code} ${error.message}',
          );
          if (!mounted) return;

          if (_retryCount < _maxRetries) {
            _retryCount++;
            _isLoading = false;
            Future.delayed(Duration(seconds: _retryCount * 2), () {
              if (mounted) _loadBanner();
            });
          } else {
            setState(() {
              _isLoading = false;
              _loadFailed = true;
              _bannerAd = null;
            });
          }
        },
      ),
    );

    _bannerAd = ad;
    _adSize = size;
    await ad.load();

    if (mounted && !_isLoaded && !_loadFailed) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.isSupported) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _bannerAd != null) {
      final height = (_adSize?.height ?? 50).toDouble();
      return Padding(
        padding: widget.margin,
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    }

    if (_isLoading) {
      return Padding(
        padding: widget.margin,
        child: SizedBox(
          height: 50,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    if (_loadFailed) {
      return const SizedBox.shrink();
    }

    return const SizedBox.shrink();
  }
}
