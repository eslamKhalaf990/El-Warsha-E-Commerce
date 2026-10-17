import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:warsha_commerce/core/localization/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_chip.dart';
import 'package:warsha_commerce/features/catalog/domain/entities/category.dart';
import 'package:warsha_commerce/features/home/presentation/cubit/home_cubit.dart';

class CategoryChipsBar extends StatelessWidget {
  final List<Category> categories;
  final int? selectedCategoryId;

  const CategoryChipsBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "All" chip
          AppChip(
            label: strings.allCategories,
            isSelected: selectedCategoryId == null,
            onTap: () {
              context.read<HomeCubit>().selectCategory(null);
            },
          ),
          const SizedBox(width: AppSpacing.s8),

          // Categories chips
          ...categories.map((category) {
            final isSelected = selectedCategoryId == category.id;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.s8),
              child: AppChip(
                label: category.name,
                isSelected: isSelected,
                onTap: () {
                  context.read<HomeCubit>().selectCategory(category.id);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
