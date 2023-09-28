import 'package:intl/intl.dart';

class FormatHelper {
  static String formatPhoneNumber(String number) {
    if (number.length != 11) {
      return number;
    } else {
      if (number.startsWith('01')) {
        return '+20 ${number.substring(1, 4)} ${number.substring(4, 7)} ${number.substring(7, 11)}';
      } else {
        return number;
      }
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd E, MMMM y hh:mm a').format(date);
  }
   static String formatDateForFilePath(DateTime date) {
    return DateFormat('dd E, MMMM y hh_mm a').format(date);
  }
}
