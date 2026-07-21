import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../constants/app_spacing.dart';

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}

class MonthlyRingSkeleton extends StatelessWidget {
  const MonthlyRingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: _SkeletonCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const Bone.circle(size: 108),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.text(width: 140),
                  const SizedBox(height: AppSpacing.sm),
                  for (var i = 0; i < 3; i++)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Bone.text(width: double.infinity),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyCardsSkeleton extends StatelessWidget {
  const WeeklyCardsSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: _WeeklyCardSkeleton(),
            ),
        ],
      ),
    );
  }
}

class _WeeklyCardSkeleton extends StatelessWidget {
  const _WeeklyCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Bone.text(width: 80),
              Bone.button(width: 54, height: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          const Bone.text(width: 120),
          const SizedBox(height: AppSpacing.md),
          const Bone(
            height: 8,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Bone.text(width: 90), Bone.text(width: 70)],
          ),
        ],
      ),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        120,
      ),
      children: const [
        Skeletonizer.zone(child: Bone.text(width: 160, fontSize: 26)),
        SizedBox(height: AppSpacing.sm),
        MonthlyRingSkeleton(),
        SizedBox(height: AppSpacing.lg),
        Skeletonizer.zone(child: Bone.text(width: 140, fontSize: 18)),
        SizedBox(height: AppSpacing.xs),
        WeeklyCardsSkeleton(),
      ],
    );
  }
}

class ExpenseListSkeleton extends StatelessWidget {
  const ExpenseListSkeleton({super.key, this.count = 7});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        itemCount: count,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) => const _TileSkeleton(square: true),
      ),
    );
  }
}

class NotificationsSkeleton extends StatelessWidget {
  const NotificationsSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        children: [
          const Bone.text(width: 120, fontSize: 18),
          const SizedBox(height: AppSpacing.xs),
          for (var i = 0; i < count; i++)
            const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: _TileSkeleton(square: false),
            ),
        ],
      ),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton({required this.square});

  final bool square;

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          if (square)
            const Bone.square(size: 44, uniRadius: AppSpacing.radiusSm)
          else
            const Bone.circle(size: 40),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(width: 140),
                SizedBox(height: 6),
                Bone.text(width: 90),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Bone.text(width: 56),
        ],
      ),
    );
  }
}

class MembersSkeleton extends StatelessWidget {
  const MembersSkeleton({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Bone.circle(size: 40),
                  SizedBox(width: AppSpacing.sm),
                  Bone.text(width: 160),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        children: const [
          Row(
            children: [
              Bone.circle(size: 64),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: 130, fontSize: 18),
                    SizedBox(height: 8),
                    Bone.text(width: 170),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Bone.text(width: 120, fontSize: 18),
          SizedBox(height: AppSpacing.sm),
          _SkeletonCard(child: Bone.text(width: double.infinity)),
          SizedBox(height: AppSpacing.lg),
          Bone.text(width: 100, fontSize: 18),
          SizedBox(height: AppSpacing.sm),
          Bone.button(width: double.infinity, height: 48),
          SizedBox(height: AppSpacing.sm),
          Bone.button(width: double.infinity, height: 48),
        ],
      ),
    );
  }
}

class WeekDetailsSkeleton extends StatelessWidget {
  const WeekDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          120,
        ),
        children: [
          _SkeletonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Bone.text(width: 140),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    for (var i = 0; i < 3; i++)
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bone.text(width: 60, fontSize: 18),
                              SizedBox(height: 4),
                              Bone.text(width: 44),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Bone.text(width: 180, fontSize: 18),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: const [
              Bone.button(width: 56, height: 32),
              SizedBox(width: AppSpacing.xs),
              Bone.button(width: 56, height: 32),
              SizedBox(width: AppSpacing.xs),
              Bone.button(width: 56, height: 32),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Bone(
            height: 240,
            borderRadius: BorderRadius.all(
              Radius.circular(AppSpacing.radiusMd),
            ),
          ),
        ],
      ),
    );
  }
}
