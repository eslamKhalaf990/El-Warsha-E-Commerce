import 'package:intl/intl.dart';

class MoneyUtils {
  static String formatMinor(int minorUnits, {String symbol = 'LE'}) {
    // Convert minor units (piastres) to major units (LE / Egyptian Pound)
    final major = minorUnits / 100.0;

    final formatter = NumberFormat('#,##0.00');
    return '${formatter.format(major)} $symbol';
  }
}
