import 'package:intl/intl.dart';

extension NumExtensions on num {
  String get toCurrency =>
      NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(this);

  String get toPercentage =>
      NumberFormat.percentPattern().format(this / 100);
}
