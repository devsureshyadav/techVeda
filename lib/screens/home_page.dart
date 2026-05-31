import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tech_veda/data/courses_data.dart';
import 'package:tech_veda/models/course.dart';
import 'package:tech_veda/features/version/provider/version_provider.dart';
import 'package:tech_veda/screens/developer.dart';
import 'package:tech_veda/theme/app_theme.dart';
import 'package:tech_veda/widgets/home/category_filter_bar.dart';
import 'package:tech_veda/widgets/home/course_section.dart';
import 'package:tech_veda/widgets/home/home_hero.dart';
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
      final isUpdateAvailable =
          await Provider.of<VersionProvider>(context, listen: false)
              .checkForUpdate();
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

  @override
  Widget build(BuildContext context) {
    final categories = _visibleCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHero(
              searchController: _searchController,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onDeveloperTap: () => Get.to(
                () => const DeveloperDetailsScreen(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 300),
              ),
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
                (context, index) => CourseSection(
                  category: categories[index],
                ),
                childCount: categories.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
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
