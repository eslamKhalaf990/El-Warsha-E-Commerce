import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:warsha_commerce/core/theme/app_colors.dart';
import 'package:warsha_commerce/core/theme/app_radius.dart';
import 'package:warsha_commerce/core/theme/app_spacing.dart';
import 'package:warsha_commerce/core/widgets/app_button.dart';
import 'package:warsha_commerce/core/widgets/app_container.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:warsha_commerce/features/auth/presentation/cubit/auth_state.dart';
import 'package:warsha_commerce/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_cubit.dart';
import 'package:warsha_commerce/features/shipping/presentation/cubit/shipping_state.dart';

class CheckoutAuthCard extends StatefulWidget {
  final CheckoutCubit checkoutCubit;

  const CheckoutAuthCard({super.key, required this.checkoutCubit});

  @override
  State<CheckoutAuthCard> createState() => _CheckoutAuthCardState();
}

class _CheckoutAuthCardState extends State<CheckoutAuthCard> {
  // Login Controllers
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Sign Up Controllers
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupPhoneController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupCityController = TextEditingController();
  final TextEditingController _signupAddressController =
      TextEditingController();
  String? _signupGovernorate;

  // OTP & Reset Controllers
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _forgotEmailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _obscureLoginPassword = true;
  bool _obscureSignupPassword = true;
  bool _obscureNewPassword = true;

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupPhoneController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupCityController.dispose();
    _signupAddressController.dispose();
    _otpController.dispose();
    _forgotEmailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.isAuthenticated && authState.customer != null) {
          widget.checkoutCubit.populateFromCustomer(authState.customer!);
        }
      },
      builder: (context, authState) {
        if (authState.isAuthenticated && authState.customer != null) {
          return _buildAuthenticatedCard(context, authState);
        }

        return AppContainer.surface(
          radius: AppRadius.card,
          padding: const EdgeInsetsDirectional.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.champagne.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Icon(
                      Iconsax.user_tag,
                      size: 20,
                      color: AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'بيانات العميل والحساب',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepWine,
                          ),
                        ),
                        Text(
                          'سجّل دخولك أو أنشئ حسابك لمتابعة الطلب وحفظ الشحنة',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),

              // Segmented switcher (Only in Login or SignUp mode)
              if (authState.activeMode == CheckoutAuthMode.login ||
                  authState.activeMode == CheckoutAuthMode.signUp)
                _buildModeSwitcher(context, authState),

              const SizedBox(height: AppSpacing.s16),

              // Alerts (Error & Info)
              if (authState.errorMessage != null) ...[
                _buildAlertBox(message: authState.errorMessage!, isError: true),
                const SizedBox(height: AppSpacing.s16),
              ],
              if (authState.message != null) ...[
                _buildAlertBox(message: authState.message!, isError: false),
                const SizedBox(height: AppSpacing.s16),
              ],

              // Mode Content
              switch (authState.activeMode) {
                CheckoutAuthMode.login => _buildLoginForm(context, authState),
                CheckoutAuthMode.signUp => _buildSignUpForm(context, authState),
                CheckoutAuthMode.verifyOtp => _buildVerifyOtpView(
                  context,
                  authState,
                ),
                CheckoutAuthMode.forgotPassword => _buildForgotPasswordView(
                  context,
                  authState,
                ),
                CheckoutAuthMode.resetPassword => _buildResetPasswordView(
                  context,
                  authState,
                ),
              },
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthenticatedCard(BuildContext context, AuthState authState) {
    final customer = authState.customer!;
    final authCubit = context.read<AuthCubit>();

    return AppContainer.surface(
      radius: AppRadius.card,
      padding: const EdgeInsetsDirectional.all(AppSpacing.s16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.burgundy.withValues(alpha: 0.1),
            child: const Icon(
              Iconsax.user,
              color: AppColors.burgundy,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'مرحباً، ${customer.fullName}',
                      style: GoogleFonts.cairo(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepWine,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppStatusColors.successBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'مسجّل',
                        style: GoogleFonts.cairo(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppStatusColors.successText,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  customer.email.isNotEmpty ? customer.email : customer.phone,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              authCubit.logout();
              widget.checkoutCubit.clearCustomerDetails();
            },
            icon: const Icon(
              Iconsax.logout,
              size: 16,
              color: AppColors.burgundy,
            ),
            label: Text(
              'تبديل الحساب',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.burgundy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitcher(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();
    final isLogin = state.activeMode == CheckoutAuthMode.login;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => authCubit.switchMode(CheckoutAuthMode.login),
              borderRadius: BorderRadius.circular(AppRadius.card - 2),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isLogin ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.card - 2),
                  boxShadow: isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'تسجيل الدخول (لدي حساب)',
                  style: GoogleFonts.cairo(
                    fontSize: 12.5,
                    fontWeight: isLogin ? FontWeight.w700 : FontWeight.w500,
                    color: isLogin ? AppColors.deepWine : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => authCubit.switchMode(CheckoutAuthMode.signUp),
              borderRadius: BorderRadius.circular(AppRadius.card - 2),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !isLogin ? AppColors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.card - 2),
                  boxShadow: !isLogin
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  'مستخدم جديد (إنشاء حساب)',
                  style: GoogleFonts.cairo(
                    fontSize: 12.5,
                    fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w500,
                    color: !isLogin ? AppColors.deepWine : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'البريد الإلكتروني',
          controller: _loginEmailController,
          hint: 'user@example.com',
          icon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.s12),
        _buildInputField(
          label: 'كلمة المرور',
          controller: _loginPasswordController,
          hint: '••••••••',
          icon: Iconsax.lock,
          obscureText: _obscureLoginPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureLoginPassword ? Iconsax.eye_slash : Iconsax.eye,
              size: 18,
              color: AppColors.muted,
            ),
            onPressed: () {
              setState(() {
                _obscureLoginPassword = !_obscureLoginPassword;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: InkWell(
            onTap: () {
              if (_loginEmailController.text.isNotEmpty) {
                _forgotEmailController.text = _loginEmailController.text;
              }
              authCubit.switchMode(CheckoutAuthMode.forgotPassword);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'نسيت كلمة المرور؟',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.burgundy,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppButton.primary(
          label: 'تسجيل الدخول ومتابعة الطلب',
          isLoading: state.isLoading,
          onPressed: () {
            final email = _loginEmailController.text.trim();
            final password = _loginPasswordController.text;
            if (email.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور'),
                ),
              );
              return;
            }
            authCubit.login(email: email, password: password);
          },
        ),
      ],
    );
  }

  Widget _buildSignUpForm(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInputField(
          label: 'الاسم بالكامل',
          controller: _signupNameController,
          hint: 'اكتب اسمك الثلاثي',
          icon: Iconsax.user,
        ),
        const SizedBox(height: AppSpacing.s12),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'رقم الموبايل',
                controller: _signupPhoneController,
                hint: '01xxxxxxxxx',
                icon: Iconsax.call,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: _buildInputField(
                label: 'البريد الإلكتروني',
                controller: _signupEmailController,
                hint: 'user@example.com',
                icon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        _buildInputField(
          label: 'كلمة المرور (6 أحرف على الأقل)',
          controller: _signupPasswordController,
          hint: '••••••••',
          icon: Iconsax.lock,
          obscureText: _obscureSignupPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureSignupPassword ? Iconsax.eye_slash : Iconsax.eye,
              size: 18,
              color: AppColors.muted,
            ),
            onPressed: () {
              setState(() {
                _obscureSignupPassword = !_obscureSignupPassword;
              });
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Iconsax.map_1,
                        size: 14,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'المحافظة',
                        style: GoogleFonts.cairo(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<ShippingCubit, ShippingState>(
                    builder: (context, shippingState) {
                      final options = shippingState.governorateNames;
                      final currentValue = options.contains(_signupGovernorate)
                          ? _signupGovernorate
                          : (options.isNotEmpty ? options.first : null);

                      return Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.ivory,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: AppColors.line),
                        ),
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentValue,
                            isExpanded: true,
                            icon: const Icon(
                              Iconsax.arrow_down_1,
                              size: 16,
                              color: AppColors.deepWine,
                            ),
                            items: options.map((gov) {
                              return DropdownMenuItem<String>(
                                value: gov,
                                child: Text(
                                  gov,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (selected) {
                              if (selected != null) {
                                setState(() {
                                  _signupGovernorate = selected;
                                });
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: _buildInputField(
                label: 'المدينة / المنطقة',
                controller: _signupCityController,
                hint: 'مثال: المعادي',
                icon: Iconsax.buildings,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        _buildInputField(
          label: 'العنوان بالتفصيل',
          controller: _signupAddressController,
          hint: 'الشارع، رقم العمارة، الشقة',
          icon: Iconsax.house,
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppButton.primary(
          label: 'إنشاء الحساب ومتابعة الطلب',
          isLoading: state.isLoading,
          onPressed: () {
            final name = _signupNameController.text.trim();
            final phone = _signupPhoneController.text.trim();
            final email = _signupEmailController.text.trim();
            final password = _signupPasswordController.text;
            final address = _signupAddressController.text.trim();

            if (name.isEmpty ||
                phone.isEmpty ||
                email.isEmpty ||
                password.isEmpty ||
                address.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يرجى ملء جميع الحقول الإلزامية')),
              );
              return;
            }

            authCubit.signUp(
              name: name,
              phone: phone,
              email: email,
              password: password,
              governorate: _signupGovernorate ??
                  (context.read<ShippingCubit>().state.governorateNames.firstOrNull ?? ''),
              city: _signupCityController.text.trim(),
              address: address,
            );
          },
        ),
      ],
    );
  }

  Widget _buildVerifyOtpView(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.champagne.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تأكيد الحساب عبر رمز التحقق (OTP)',
                style: GoogleFonts.cairo(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepWine,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'تم إرسال كود التحقق المكون من 6 أرقام إلى بريدك:',
                style: GoogleFonts.cairo(fontSize: 12, color: AppColors.muted),
              ),
              Text(
                state.email,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.burgundy,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        _buildInputField(
          label: 'رمز التحقق (OTP)',
          controller: _otpController,
          hint: '123456',
          icon: Iconsax.key,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppButton.primary(
          label: 'تأكيد الرمز وتفعيل الحساب',
          isLoading: state.isLoading,
          onPressed: () {
            authCubit.verifyOtp(otp: _otpController.text);
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => authCubit.resendOtp(),
              child: Text(
                'إعادة إرسال الرمز',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.burgundy,
                ),
              ),
            ),
            TextButton(
              onPressed: () => authCubit.switchMode(CheckoutAuthMode.login),
              child: Text(
                'الرجوع لتسجيل الدخول',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.muted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForgotPasswordView(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'استعادة كلمة المرور',
          style: GoogleFonts.cairo(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.deepWine,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'أدخل بريدك الإلكتروني وسنرسل لك كود التحقق لإعادة تعيين كلمة المرور.',
          style: GoogleFonts.cairo(fontSize: 12, color: AppColors.muted),
        ),
        const SizedBox(height: AppSpacing.s16),
        _buildInputField(
          label: 'البريد الإلكتروني',
          controller: _forgotEmailController,
          hint: 'user@example.com',
          icon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.s16),
        AppButton.primary(
          label: 'إرسال كود الاستعادة',
          isLoading: state.isLoading,
          onPressed: () {
            authCubit.forgotPassword(email: _forgotEmailController.text);
          },
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => authCubit.switchMode(CheckoutAuthMode.login),
            child: Text(
              'الرجوع لتسجيل الدخول',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.burgundy,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordView(BuildContext context, AuthState state) {
    final authCubit = context.read<AuthCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'تعيين كلمة مرور جديدة',
          style: GoogleFonts.cairo(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.deepWine,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'أدخل رمز التحقق المرسل إلى بريدك (${state.email}) وكلمة المرور الجديدة.',
          style: GoogleFonts.cairo(fontSize: 12, color: AppColors.muted),
        ),
        const SizedBox(height: AppSpacing.s16),
        _buildInputField(
          label: 'رمز التحقق (OTP)',
          controller: _otpController,
          hint: '123456',
          icon: Iconsax.key,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.s12),
        _buildInputField(
          label: 'كلمة المرور الجديدة',
          controller: _newPasswordController,
          hint: '••••••••',
          icon: Iconsax.lock,
          obscureText: _obscureNewPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword ? Iconsax.eye_slash : Iconsax.eye,
              size: 18,
              color: AppColors.muted,
            ),
            onPressed: () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            },
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        AppButton.primary(
          label: 'حفظ كلمة المرور ومتابعة الطلب',
          isLoading: state.isLoading,
          onPressed: () {
            authCubit.resetPassword(
              otp: _otpController.text,
              newPassword: _newPasswordController.text,
            );
          },
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => authCubit.switchMode(CheckoutAuthMode.login),
            child: Text(
              'إلغاء والرجوع لتسجيل الدخول',
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBox({required String message, required bool isError}) {
    final bgColor = isError
        ? AppStatusColors.errorBackground
        : AppStatusColors.successBackground;
    final textColor = isError
        ? AppStatusColors.errorText
        : AppStatusColors.successText;
    final iconData = isError ? Iconsax.danger : Iconsax.tick_circle;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(iconData, size: 18, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.cairo(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
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
            obscureText: obscureText,
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
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
