import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/l10n/app_strings.dart';
import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/utils/receipt_picker/receipt_picker.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/core/widgets/app_text.dart';
import 'package:warsha_commerce/features/checkout/domain/entities/receipt_attachment.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_state.dart';

class CheckoutPaymentSelector extends StatefulWidget {
  final CheckoutState state;
  final CheckoutCubit cubit;

  const CheckoutPaymentSelector({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  State<CheckoutPaymentSelector> createState() =>
      _CheckoutPaymentSelectorState();
}

class _CheckoutPaymentSelectorState extends State<CheckoutPaymentSelector> {
  String? _copiedMethod;
  late final TextEditingController _downPaymentController;

  @override
  void initState() {
    super.initState();
    _downPaymentController = TextEditingController(
      text: widget.state.downPayment > 0
          ? (widget.state.downPayment / 100.0).toStringAsFixed(
              widget.state.downPayment % 100 == 0 ? 0 : 2,
            )
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant CheckoutPaymentSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.downPayment != widget.state.downPayment) {
      final currentParsed =
          ((double.tryParse(_downPaymentController.text.trim()) ?? 0.0) * 100)
              .round();
      if (currentParsed != widget.state.downPayment) {
        _downPaymentController.text = widget.state.downPayment > 0
            ? (widget.state.downPayment / 100.0).toStringAsFixed(
                widget.state.downPayment % 100 == 0 ? 0 : 2,
              )
            : '';
      }
    }
  }

  @override
  void dispose() {
    _downPaymentController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String methodKey, String number) {
    Clipboard.setData(ClipboardData(text: number));
    widget.cubit.updatePaymentMethod(methodKey);
    setState(() {
      _copiedMethod = methodKey;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppStrings.copied} ($number)',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.deepWine,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _copiedMethod == methodKey) {
        setState(() {
          _copiedMethod = null;
        });
      }
    });
  }

  Future<void> _handlePickReceipt() async {
    final receipt = await pickReceiptFile();
    if (receipt != null && mounted) {
      widget.cubit.updateDepositReceipt(receipt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = widget.cubit;
    final isReceiptMissing =
        state.depositReceipt == null &&
        state.errorMessage == AppStrings.depositScreenshotRequired;
    final isDownPaymentMissing =
        state.downPayment <= 0 &&
        state.errorMessage == AppStrings.downPaymentRequired;

    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const Row(
            children: [
              Icon(Iconsax.wallet_3, size: 22, color: AppColors.burgundy),
              SizedBox(width: AppSpacing.s8),
              AppText.title(
                AppStrings.paymentMethod,
                weight: FontWeight.w700,
                color: AppColors.deepWine,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.paymentMethodsAllowedSubtitle,
            style: GoogleFonts.cairo(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.burgundy,
            ),
          ),
          const SizedBox(height: 16),

          // 1. Instapay Option Widget with Dedicated Copy Box
          _buildPaymentCardWithCopy(
            methodKey: 'Instapay',
            title: AppStrings.instapay,
            subtitle: AppStrings.instapayDesc,
            numberLabel: AppStrings.instapayNumberLabel,
            numberValue: AppStrings.instapayNumber,
            instruction: AppStrings.instapayInstructions,
            icon: Iconsax.wallet_2,
            isSelected: state.paymentMethod == 'Instapay',
          ),
          const SizedBox(height: 14),

          // 2. Vodafone Cash Option Widget with Dedicated Copy Box
          _buildPaymentCardWithCopy(
            methodKey: 'Vodafone Cash',
            title: AppStrings.vodafoneCash,
            subtitle: AppStrings.vodafoneCashDesc,
            numberLabel: AppStrings.vodafoneCashNumberLabel,
            numberValue: AppStrings.vodafoneCashNumber,
            instruction: AppStrings.vodafoneCashInstructions,
            icon: Iconsax.mobile,
            isSelected: state.paymentMethod == 'Vodafone Cash',
          ),
          const SizedBox(height: 20),

          // Friendly Deposit Screenshot Requirement Notice, Downpayment Input & Upload Area
          _buildDepositScreenshotSection(
            state,
            cubit,
            isReceiptMissing,
            isDownPaymentMissing,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCardWithCopy({
    required String methodKey,
    required String title,
    required String subtitle,
    required String numberLabel,
    required String numberValue,
    required String instruction,
    required IconData icon,
    required bool isSelected,
  }) {
    final isCopied = _copiedMethod == methodKey;

    return InkWell(
      onTap: () => widget.cubit.updatePaymentMethod(methodKey),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blush.withValues(alpha: 0.6)
              : AppColors.ivory,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isSelected ? AppColors.burgundy : AppColors.line,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Selection Header
            Row(
              children: [
                // Radio indicator
                Icon(
                  isSelected ? Iconsax.record_circle : Iconsax.record,
                  color: isSelected ? AppColors.burgundy : AppColors.muted,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s12),

                // Icon Badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white : AppColors.blush,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.burgundy),
                ),
                const SizedBox(width: AppSpacing.s12),

                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.deepWine
                              : AppColors.ink,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Dedicated Copy Box Widget for this payment method
            Container(
              padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: isSelected
                      ? AppColors.burgundy.withValues(alpha: 0.3)
                      : AppColors.line,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 14, color: AppColors.burgundy),
                      const SizedBox(width: 6),
                      Text(
                        numberLabel,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // The number to copy
                      Expanded(
                        child: SelectableText(
                          numberValue,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepWine,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      // Distinct Copy Button
                      InkWell(
                        onTap: () => _copyToClipboard(methodKey, numberValue),
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isCopied
                                ? AppStatusColors.successBackground
                                : (isSelected
                                      ? AppColors.burgundy
                                      : AppColors.blush),
                            borderRadius: BorderRadius.circular(
                              AppRadius.small,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isCopied ? Iconsax.tick_circle : Iconsax.copy,
                                size: 14,
                                color: isCopied
                                    ? AppStatusColors.successText
                                    : (isSelected
                                          ? AppColors.white
                                          : AppColors.burgundy),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isCopied ? AppStrings.copied : AppStrings.copy,
                                style: GoogleFonts.cairo(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isCopied
                                      ? AppStatusColors.successText
                                      : (isSelected
                                            ? AppColors.white
                                            : AppColors.burgundy),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              instruction,
              style: GoogleFonts.cairo(fontSize: 11, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepositScreenshotSection(
    CheckoutState state,
    CheckoutCubit cubit,
    bool isReceiptMissing,
    bool isDownPaymentMissing,
  ) {
    final receipt = state.depositReceipt;

    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.blush.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: (isReceiptMissing || isDownPaymentMissing)
              ? AppStatusColors.errorText
              : AppColors.burgundy.withValues(alpha: 0.25),
          width: (isReceiptMissing || isDownPaymentMissing) ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Friendly Notice Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: AppColors.burgundy.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Iconsax.camera,
                  color: AppColors.burgundy,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.depositScreenshotNoticeTitle,
                      style: GoogleFonts.cairo(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepWine,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.depositScreenshotNoticeDesc,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppColors.ink,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Downpayment input field
          _buildDownPaymentInputField(cubit, isDownPaymentMissing),
          const SizedBox(height: 14),

          // Upload Box or Preview
          if (receipt == null)
            _buildUploadDropzone(isReceiptMissing)
          else
            _buildReceiptPreview(receipt, cubit),

          if (isReceiptMissing) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Iconsax.info_circle,
                  color: AppStatusColors.errorText,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppStrings.depositScreenshotRequired,
                    style: GoogleFonts.cairo(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppStatusColors.errorText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDownPaymentInputField(CheckoutCubit cubit, bool isError) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Iconsax.money_send, size: 15, color: AppColors.burgundy),
            const SizedBox(width: 6),
            Text(
              AppStrings.downPaymentAmount,
              style: GoogleFonts.cairo(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: isError ? AppStatusColors.errorText : AppColors.deepWine,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isError ? AppStatusColors.errorText : AppColors.line,
              width: isError ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.s12,
            vertical: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _downPaymentController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    hintText: AppStrings.downPaymentHint,
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.muted,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: cubit.updateDownPaymentFromText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  AppStrings.currency,
                  style: GoogleFonts.cairo(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppStrings.downPaymentDesc,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: AppColors.muted,
          ),
        ),
        if (isError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Iconsax.info_circle,
                color: AppStatusColors.errorText,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppStrings.downPaymentRequired,
                  style: GoogleFonts.cairo(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppStatusColors.errorText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUploadDropzone(bool isError) {
    return InkWell(
      onTap: _handlePickReceipt,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.s16,
          vertical: 20.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isError ? AppStatusColors.errorText : AppColors.burgundy,
            width: 1.2,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.blush,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Icon(
                Iconsax.document_upload,
                color: AppColors.burgundy,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.uploadDepositReceipt,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isError ? AppStatusColors.errorText : AppColors.deepWine,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.uploadDepositReceiptHint,
              style: GoogleFonts.cairo(fontSize: 11, color: AppColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptPreview(ReceiptAttachment receipt, CheckoutCubit cubit) {
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppStatusColors.successText.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          // Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.small),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.memory(
                receipt.bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.blush,
                  child: const Icon(
                    Iconsax.gallery,
                    color: AppColors.burgundy,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),

          // File metadata & confirmation badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.tick_circle,
                      color: AppStatusColors.successText,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.depositReceiptAttached,
                      style: GoogleFonts.cairo(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppStatusColors.successText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  receipt.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepWine,
                  ),
                ),
                Text(
                  receipt.formattedSize,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Actions: Change & Remove
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: _handlePickReceipt,
                icon: const Icon(
                  Iconsax.refresh,
                  size: 13,
                  color: AppColors.burgundy,
                ),
                label: Text(
                  AppStrings.changeReceipt,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.burgundy,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(height: 4),
              TextButton.icon(
                onPressed: () => cubit.updateDepositReceipt(null),
                icon: const Icon(
                  Iconsax.trash,
                  size: 13,
                  color: AppColors.muted,
                ),
                label: Text(
                  AppStrings.removeReceipt,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
