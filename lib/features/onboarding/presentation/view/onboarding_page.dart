import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nuigate/core/app_assets.dart';
import 'package:nuigate/core/app_colors.dart';
import 'package:nuigate/features/onboarding/logic/cubit/onboarding_cubit.dart';
import 'package:nuigate/features/onboarding/logic/cubit/onboarding_state.dart';
import 'package:nuigate/features/onboarding/presentation/widgets/onboarding_card.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
//! شوف هو بيروح فين للداش بورد ولا اللوجين بعد ما يخلص الاونبوردنج
  static final List<_OnboardingItem> _items = [
    _OnboardingItem(
      title: 'بوابتك الأكاديمية الذكية',
      subtitle:
          'انطلق في رحلة دراسية متكاملة مع منصة Nuigate التي تربطك بخدمات الجامعة بسرعة وثقة.',
      assetPath: AppAssets.onboardingAcademic,
    ),
    _OnboardingItem(
      title: 'جداولك الدراسية في لمحة',
      subtitle:
          'اطلع على مواعيد المحاضرات والاختبارات فوراً، واحفظ وقتك مع تخطيط واضح ودقيق.',
      assetPath: AppAssets.onboardingSchedule,
    ),
    _OnboardingItem(
      title: 'المهام والاختبارات تحت تحكمك',
      subtitle:
          'تابع الواجبات، سدد المواعيد النهائية، واستعد للامتحانات بكفاءة عالية.',
      assetPath: AppAssets.onboardingAssignments,
    ),
    _OnboardingItem(
      title: 'نتائجك الأكاديمية واضحة دائماً',
      subtitle:
          'راقب تقديراتك وتاريخك الدراسي بسهولة، وابقَ على اطلاع دائم بتقدمك.',
      assetPath: AppAssets.onboardingResults,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = OnboardingPage._items;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              _buildHeader(context, items.length),
              Expanded(child: _buildPageView(items)),
              _buildFooter(context, items.length),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int pageCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 60),
          const CustomText(
            'Nuigate',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          TextButton(
            onPressed: _completeOnboarding,
            child: const CustomText(
              'تخطي',
              fontSize: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(List<_OnboardingItem> items) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final currentIndex = state.currentPage;
        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  context.read<OnboardingCubit>().updatePage(index);
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: OnboardingCard(
                      title: item.title,
                      subtitle: item.subtitle,
                      assetPath: item.assetPath,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            _buildIndicator(items.length, currentIndex),
            const SizedBox(height: 14),
          ],
        );
      },
    );
  }

  Widget _buildIndicator(int pageCount, int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: isActive ? 22 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildFooter(BuildContext context, int pageCount) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isLastPage = state.currentPage == pageCount - 1;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            children: [
              if (state.currentPage > 0)
                TextButton(
                  onPressed: _onPrevious,
                  child: const CustomText(
                    'السابق',
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                )
              else
                const SizedBox(width: 84),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isLastPage ? _completeOnboarding : _onNext,
                  child: CustomText(
                    isLastPage ? 'ابدأ الآن' : 'التالي',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (!isLastPage)
                TextButton(
                  onPressed: _onPrevious,
                  child: const CustomText(
                    'السابق',
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                )
              else
                const SizedBox(width: 84),
            ],
          ),
        );
      },
    );
  }

  void _onNext() {
    final pageCount = OnboardingPage._items.length;
    context.read<OnboardingCubit>().nextPage(pageCount);
    final nextPage = context.read<OnboardingCubit>().state.currentPage;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeInOut,
    );
  }

  void _onPrevious() {
    context.read<OnboardingCubit>().previousPage();
    final previousPage = context.read<OnboardingCubit>().state.currentPage;
    _pageController.animateToPage(
      previousPage,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    await context.read<OnboardingCubit>().completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String assetPath;

  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
  });
}
