import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tech_veda/data/courses_data.dart';
import 'package:tech_veda/models/course.dart';
import 'package:tech_veda/features/ai_assistant/screens/ai_chat_screen.dart';
import 'package:tech_veda/services/admob_service.dart';
import 'package:tech_veda/features/version/provider/version_provider.dart';
import 'package:tech_veda/screens/developer.dart';
import 'package:tech_veda/theme/app_theme.dart';
import 'package:tech_veda/widgets/home/category_filter_bar.dart';
import 'package:tech_veda/widgets/home/course_section.dart';
import 'package:tech_veda/widgets/home/home_hero.dart';
import 'package:tech_veda/config/ad_config.dart';
import 'package:tech_veda/widgets/ads/banner_ad_widget.dart';
import 'package:tech_veda/widgets/home/update_dialog.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategoryId = allCategoryId;
  String _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final providerInstance =
        Provider.of<VersionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Try native Google Play in-app updates first
      final nativeUpdateHandled = await providerInstance.checkForInAppUpdate();
      if (nativeUpdateHandled) {
        // Native update is already in progress or completed, exit flow.
        return;
      }

      // 2. Fall back to custom Firestore update check if no native update was handled
      final isUpdateAvailable = await providerInstance.checkForUpdate();
      if (!mounted || !isUpdateAvailable) return;

      showModernUpdateDialog(
        context,
        downloadUrl: providerInstance.downloadUrl,
        currentVersion: providerInstance.currentVersion,
        latestVersion: providerInstance.latestVersion,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CourseCategory> get _visibleCategories => filterCategories(
        categoryId: _selectedCategoryId,
        query: _searchQuery,
      );

  int _homeListItemCount(int categoryCount) {
    if (categoryCount == 0) return 0;
    final bannerSlots = categoryCount < AdConfig.productionBanners.length
        ? categoryCount
        : AdConfig.productionBanners.length;
    return categoryCount + bannerSlots;
  }

  Widget _buildHomeListItem(List<CourseCategory> categories, int index) {
    var listIndex = 0;
    for (var i = 0; i < categories.length; i++) {
      if (listIndex++ == index) {
        return CourseSection(category: categories[i]);
      }
      if (i < AdConfig.productionBanners.length) {
        if (listIndex++ == index) {
          return BannerAdWidget(bannerIndex: i);
        }
      }
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _visibleCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const SafeArea(
        child: BannerAdWidget(bannerIndex: 2),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          AdMobService.instance.showInterstitialThen(() {
            Get.to(
              () => const AiChatScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            );
          });
        },
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text(
          'Ask AI',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHero(
              searchController: _searchController,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onDeveloperTap: () {
                AdMobService.instance.showInterstitialThen(() {
                  Get.to(
                    () => const DeveloperDetailsScreen(),
                    transition: Transition.fadeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                });
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              child: CategoryFilterBar(
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
              ),
            ),
          ),
          if (categories.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyResults(query: _searchQuery),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildHomeListItem(categories, index),
                childCount: _homeListItemCount(categories.length),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.textSecondary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No guides found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            query.isEmpty
                ? 'Try another category filter.'
                : 'No results for "$query". Try a different keyword.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
