import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  final Map<String, String> _localizedStringsEN = {
    'title': 'News App',
    'business': 'Business',
    'sports': 'Sports',
    'health': 'Health',
    'science': 'Science',
    'technology': 'Technology',
    // Add other English translations here
  };

  final Map<String, String> _localizedStringsAR = {
    'title': 'تطبيق الأخبار',
    'business': 'الأعمال',
    'sports': 'الرياضة',
    'health': 'الصحة',
    'science': 'العلوم',
    'technology': 'التكنولوجيا',
    // Add other Arabic translations here
  };

  String translate(String key) {
    if (locale.languageCode == 'ar') {
      return _localizedStringsAR[key] ?? key;
    } else {
      return _localizedStringsEN[key] ?? key;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
