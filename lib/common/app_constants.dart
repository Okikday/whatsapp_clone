import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppConstants {
  static const List<String> homeTabTitles = ["WhatsApp", "Updates", "Communities", "Calls"];
  static const List<String> defaultChatsFilters = ["All", "Unread", "Favourites", "Groups"];
  static const List<Effect> homeCamAnimforwardEffect = [MoveEffect(begin: Offset(30, 0), end: Offset.zero), FadeEffect(begin: 0, end: 1, duration: Duration(milliseconds: 500))];
  static const List<Effect> homeCamAnimBackwardEffect = [MoveEffect(begin: Offset(-30, 0), end: Offset.zero), FadeEffect(begin: 0, end: 1, duration: Duration(milliseconds: 500))];



  static const Map<String, String> whatsappLanguages = {
  "English": "(default)",
  "Nederlands": "Dutch",
  "Español": "Spanish",
  "Español (México)": "Spanish (Mexico)",
  "Français": "French",
  "Deutsch": "German",
  "Italiano": "Italian",
  "Português (Brasil)": "Portuguese (Brazil)",
  "Português (Portugal)": "Portuguese (Portugal)",
  "Русский": "Russian",
  "العربية": "Arabic",
  "हिन्दी": "Hindi",
  "বাংলা": "Bengali",
  "日本語": "Japanese",
  "中文 (简体)": "Chinese (Simplified)",
  "中文 (繁體)": "Chinese (Traditional)",
  "한국어": "Korean",
  "Türkçe": "Turkish",
  "עברית": "Hebrew",
  "Polski": "Polish",
  "Dansk": "Danish",
  "Svenska": "Swedish",
  "Norsk": "Norwegian",
  "Suomi": "Finnish",
  "Ελληνικά": "Greek",
  "Čeština": "Czech",
  "Magyar": "Hungarian",
  "ไทย": "Thai",
  "Tiếng Việt": "Vietnamese",
  "Filipino": "Filipino",
  "Українська": "Ukrainian",
  "Română": "Romanian",
  "Català": "Catalan",
  "Slovenčina": "Slovak",
  "Slovenščina": "Slovenian",
  "Hrvatski": "Croatian",
  "Srpski": "Serbian",
  "Bosanski": "Bosnian",
  "Bahasa Indonesia": "Indonesian",
  "Bahasa Melayu": "Malay",
  "தமிழ்": "Tamil",
  "తెలుగు": "Telugu",
  "ಕನ್ನಡ": "Kannada",
  "മലയാളം": "Malayalam",
  "ਪੰਜਾਬੀ": "Punjabi",
  "मराठी": "Marathi",
};

}

enum ImageSource{
  network,
  asset,
  file,
}

