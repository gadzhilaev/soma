import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../settings/models.dart';
import '../../settings/repo.dart';
import '../../windows/programs/program_details_screen.dart';
import 'capsule.dart';

/// Карточка героя для главного экрана
class HeroCard extends StatelessWidget {
  final HeroSlide slide;
  final HomeRepo? repo;
  final String? lang;

  const HeroCard({
    super.key,
    required this.slide,
    this.repo,
    this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (repo != null && lang != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProgramDetailsScreen(
                repo: repo!,
                lang: lang!,
                programId: slide.id,
                preload: ProgramDetails(
                  id: slide.id,
                  imageUrl: slide.imageUrl,
                  title: slide.title,
                  content: null,
                  views: 0,
                  comments: 0,
                  publishedAt: slide.updatedAt,
                ),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(slide.radiusPx.toDouble()),
          child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(slide.imageUrl, fit: BoxFit.cover),

            // Затемнение для читаемости текста
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.525, 0.9823],
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.0847845),
                        Color.fromRGBO(0, 0, 0, 0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // бейдж "новое"
            Positioned(
              top: 16,
              right: 16,
              child: Capsule(
                width: 60,
                height: 24,
                bg: AppColors.fromHex(slide.topBadgeBg),
                text: slide.topBadgeLabel.toUpperCase(),
              ),
            ),

            // блок слева: chip → 8 → title → 4 → subtitle
            Positioned(
              left: 16,
              right: 16,
              top: 16 + 24 + 54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Capsule(
                    width: 88,
                    height: 24,
                    bg: AppColors.fromHex(slide.leftChipBg),
                    text: slide.leftChipLabel.toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slide.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heroTitle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heroSubtitle,
                  ),
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

