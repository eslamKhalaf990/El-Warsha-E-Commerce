import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 680.0;
  static const double tablet = 1024.0;
  static const double desktop = 1024.0;
  static const double maxContentWidth = 1200.0;
}

extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < Breakpoints.mobile;
  bool get isTablet =>
      MediaQuery.sizeOf(this).width >= Breakpoints.mobile &&
      MediaQuery.sizeOf(this).width < Breakpoints.tablet;
  bool get isDesktop => MediaQuery.sizeOf(this).width >= Breakpoints.desktop;
}
