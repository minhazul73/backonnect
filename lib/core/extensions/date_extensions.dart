import 'package:backonnect/core/utils/formatters/date_formatters.dart';

extension DateExtensions on DateTime {
  String get timeAgo => DateFormatters.formatRelative(this);
  String get formatted => DateFormatters.formatDate(this);
  String get formattedWithTime => DateFormatters.formatDateTime(this);
}
