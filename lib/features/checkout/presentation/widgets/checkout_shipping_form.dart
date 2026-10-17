import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/governorates.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/widgets/checkout_auth_card.dart';
import 'package:warsha_commerce/features/shipping/data/models/governorate_model.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_state.dart';

class CheckoutShippingForm extends StatefulWidget {
  final CheckoutState state;
  final CheckoutCubit cubit;

  const CheckoutShippingForm({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  State<CheckoutShippingForm> createState() => _CheckoutShippingFormState();
}

class _CheckoutShippingFormState extends State<CheckoutShippingForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _secondaryPhoneController;
  late final TextEditingController _cityController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.fullName);
    _phoneController = TextEditingController(text: widget.state.phone);
    _secondaryPhoneController = TextEditingController(
      text: widget.state.secondaryPhone,
    );
    _cityController = TextEditingController(text: widget.state.city);
    _addressController = TextEditingController(text: widget.state.addressLine);
    _notesController = TextEditingController(text: widget.state.notes);
  }

  @override
  void didUpdateWidget(covariant CheckoutShippingForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.fullName != widget.state.fullName &&
        _nameController.text != widget.state.fullName) {
      _nameController.text = widget.state.fullName;
    }
    if (oldWidget.state.phone != widget.state.phone &&
        _phoneController.text != widget.state.phone) {
      _phoneController.text = widget.state.phone;
    }
    if (oldWidget.state.secondaryPhone != widget.state.secondaryPhone &&
        _secondaryPhoneController.text != widget.state.secondaryPhone) {
      _secondaryPhoneController.text = widget.state.secondaryPhone;
    }
    if (oldWidget.state.city != widget.state.city &&
        _cityController.text != widget.state.city) {
      _cityController.text = widget.state.city;
    }
    if (oldWidget.state.addressLine != widget.state.addressLine &&
        _addressController.text != widget.state.addressLine) {
      _addressController.text = widget.state.addressLine;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _secondaryPhoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final isAuthenticated = authState.isAuthenticated;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // In-checkout Auth Card (Login, Register, OTP, Forgot/Reset Password, or Logged In banner)
            CheckoutAuthCard(checkoutCubit: widget.cubit),

            if (isAuthenticated) ...[
              const SizedBox(height: AppSpacing.s24),
              AppContainer.surface(
                radius: AppRadius.card,
                padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Iconsax.location,
                          size: 22,
                          color: AppColors.burgundy,
                        ),
                        SizedBox(width: AppSpacing.s8),
                        AppText.title(
                          AppStrings.shippingDetails,
                          weight: FontWeight.w700,
                          color: AppColors.deepWine,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Full Name Field
                    _buildTextField(
                      label: AppStrings.fullName,
                      controller: _nameController,
                      icon: Iconsax.user,
                      onChanged: widget.cubit.updateFullName,
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Phones Row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 500) {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: AppStrings.phone,
                                  controller: _phoneController,
                                  icon: Iconsax.call,
                                  keyboardType: TextInputType.phone,
                                  onChanged: widget.cubit.updatePhone,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s16),
                              Expanded(
                                child: _buildTextField(
                                  label: AppStrings.secondaryPhone,
                                  controller: _secondaryPhoneController,
                                  icon: Iconsax.mobile,
                                  keyboardType: TextInputType.phone,
                                  onChanged: widget.cubit.updateSecondaryPhone,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              _buildTextField(
                                label: AppStrings.phone,
                                controller: _phoneController,
                                icon: Iconsax.call,
                                keyboardType: TextInputType.phone,
                                onChanged: widget.cubit.updatePhone,
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              _buildTextField(
                                label: AppStrings.secondaryPhone,
                                controller: _secondaryPhoneController,
                                icon: Iconsax.mobile,
                                keyboardType: TextInputType.phone,
                                onChanged: widget.cubit.updateSecondaryPhone,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Governorate Dropdown & City Row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 500;
                        final govField = _buildGovernorateDropdown();
                        final cityField = _buildTextField(
                          label: AppStrings.city,
                          controller: _cityController,
                          icon: Iconsax.buildings,
                          onChanged: widget.cubit.updateCity,
                        );

                        if (isWide) {
                          return Row(
                            children: [
                              Expanded(child: govField),
                              const SizedBox(width: AppSpacing.s16),
                              Expanded(child: cityField),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              govField,
                              const SizedBox(height: AppSpacing.s16),
                              cityField,
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Detailed Address Field
                    _buildTextField(
                      label: AppStrings.address,
                      controller: _addressController,
                      icon: Iconsax.house,
                      maxLines: 2,
                      onChanged: widget.cubit.updateAddressLine,
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Order Delivery Notes
                    _buildTextField(
                      label: AppStrings.orderNotes,
                      hint: AppStrings.notesPlaceholder,
                      controller: _notesController,
                      icon: Iconsax.note_2,
                      maxLines: 2,
                      onChanged: widget.cubit.updateNotes,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.muted),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.ivory,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.line),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s12,
            vertical: 4,
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: GoogleFonts.cairo(
              fontSize: 13.5,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.cairo(
                fontSize: 12.5,
                color: AppColors.muted,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildGovernorateDropdown() {
    return BlocBuilder<ShippingCubit, ShippingState>(
      builder: (context, shippingState) {
        final governoratesList = shippingState.governorates;
        final isListEmpty = governoratesList.isEmpty;
        final currentValue = governoratesList.any(
          (g) => g.governorate == widget.state.governorate,
        )
            ? widget.state.governorate
            : (governoratesList.isNotEmpty
                ? governoratesList.first.governorate
                : widget.state.governorate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.map_1, size: 14, color: AppColors.muted),
                const SizedBox(width: 4),
                Text(
                  AppStrings.governorate,
                  style: GoogleFonts.cairo(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                if (shippingState.isLoading) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.burgundy,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.line),
              ),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.s12,
              ),

              alignment: Alignment.center,
              child: isListEmpty && shippingState.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'جاري تحميل المحافظات...',
                          style: GoogleFonts.cairo(
                            fontSize: 12.5,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.burgundy,
                          ),
                        ),
                      ],
                    )
                  : DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: currentValue,
                        isExpanded: true,
                        icon: const Icon(
                          Iconsax.arrow_down_1,
                          color: AppColors.deepWine,
                        ),
                        dropdownColor: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        items: (governoratesList.isNotEmpty
                                ? governoratesList
                                : Governorates.all
                                    .map(
                                      (name) => GovernorateModel(
                                        governorate: name,
                                        price: Governorates.getPrice(name),
                                      ),
                                    )
                                    .toList())
                            .map((govItem) {
                          return DropdownMenuItem<String>(
                            value: govItem.governorate,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  govItem.governorate,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  '${govItem.price.toStringAsFixed(0)} ج.م شحن',
                                  style: GoogleFonts.cairo(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          if (selected != null) {
                            final priceInMinor =
                                shippingState.getMinorPriceFor(selected);
                            widget.cubit.updateGovernorate(selected, priceInMinor);
                          }
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
