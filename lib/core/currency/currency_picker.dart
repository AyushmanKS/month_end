import '../../core/constants/app_assets.dart';
import '../../core/widgets/app_icon.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'currency.dart';

Future<String?> showCurrencyPicker(
  BuildContext context, {
  required String selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _CurrencySheet(selected: selected),
  );
}

class _CurrencySheet extends StatelessWidget {
  const _CurrencySheet({required this.selected});

  final String selected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Text(
                'Choose currency',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final currency in Currencies.all)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: Text(
                          currency.symbol,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Text(currency.name),
                      subtitle: Text(currency.code),
                      trailing: currency.code == selected
                          ? const AppIcon(
                              AppAssets.checkCircle,
                              color: AppColors.primary,
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(currency.code),
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
