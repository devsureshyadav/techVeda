import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tech_veda/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

void showModernUpdateDialog(
  BuildContext context, {
  required String downloadUrl,
  required String currentVersion,
  required String latestVersion,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.5),
                        AppColors.glow.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.system_update_alt_rounded,
                    color: AppColors.accentSecondary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Update available',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A newer version of TechVeda is ready. Update for the latest guides and fixes.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _VersionRow(
                  label: 'Current',
                  version: currentVersion,
                ),
                const SizedBox(height: 8),
                _VersionRow(
                  label: 'Latest',
                  version: latestVersion,
                  highlight: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Later',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: () {
                          if (downloadUrl.isNotEmpty) {
                            launchUrl(Uri.parse(downloadUrl));
                          } else {
                            Get.snackbar(
                              'Error',
                              'Download URL not found',
                              colorText: Colors.white,
                              backgroundColor: const Color(0xFFB71C1C),
                              margin: const EdgeInsets.all(16),
                              borderRadius: 14,
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Update now',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _VersionRow extends StatelessWidget {
  const _VersionRow({
    required this.label,
    required this.version,
    this.highlight = false,
  });

  final String label;
  final String version;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accent.withValues(alpha: 0.15)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? AppColors.accent.withValues(alpha: 0.4)
              : AppColors.cardBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            version,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.accentSecondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
