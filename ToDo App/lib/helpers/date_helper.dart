import 'package:intl/intl.dart';

class DateFormatHelper {
  static String formatYMD(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
  static String formatDayShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }
  static String formatDayNum(DateTime date){
    return DateFormat('dd').format(date);
  }
}
