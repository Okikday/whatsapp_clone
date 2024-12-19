import 'package:intl/intl.dart';

class Formatter{
 static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      // Show the date if more than a week ago
      return DateFormat('MMM d').format(dateTime); // e.g., "Dec 14"
    } else if (difference.inDays >= 2) {
      // Show the day of the week, e.g., "Thursday"
      return DateFormat('EEEE').format(dateTime); 
    } else if (difference.inDays == 1) {
      // Show "Yesterday" for one day ago
      return 'Yesterday';
    } else if (difference.inHours >= 1) {
      // Show hours ago
      if(difference.inHours == 1) return '1 hour ago';
      return '${difference.inHours} hours ago';
      
    } else if (difference.inMinutes >= 1) {
      // Show minutes ago
      return '${difference.inMinutes} minutes ago';
    } else {
      // Default to "just now"
      return 'just now';
    }
  }
}