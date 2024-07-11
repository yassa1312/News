// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'news_select_country_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, String> _localizedStringsEN = {
    "title": "News App",
    "business": "Business",
    "sports": "Sports",
    "health": "Health",
    "science": "Science",
    "technology": "Technology",
    "settings": "Settings",
    "country": "Country",
    "language": "Language",
    "theme": "Theme",
    "notification": "Notification",
    "enabled": "Enabled",
    "disabled": "Disabled"
  };

  static final Map<String, String> _localizedStringsAR = {
    "title": "تطبيق الأخبار",
    "business": "الأعمال",
    "sports": "الرياضة",
    "health": "الصحة",
    "science": "العلوم",
    "technology": "التكنولوجيا",
    "settings": "الإعدادات",
    "country": "الدولة",
    "language": "اللغة",
    "theme": "السمة",
    "notification": "الإشعار",
    "enabled": "تمكين",
    "disabled": "تعطيل"
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

class NewsSettingScreen extends StatefulWidget {
  const NewsSettingScreen({
    Key? key,
    required this.currentCountry,
    required this.currentLanguage,
    required this.currentTheme,
    required this.onCountryChanged,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  final String currentCountry;
  final String currentLanguage;
  final bool currentTheme;
  final Function(String) onCountryChanged;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;

  @override
  State<NewsSettingScreen> createState() => _NewsSettingScreenState();
}

class _NewsSettingScreenState extends State<NewsSettingScreen> {
  String selectedCountry = 'us';
  String selectedLanguage = 'English';
  String selectedTheme = 'Light';
  bool notificationEnabled = true;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _loadSelectedCountry();
    _loadSelectedTheme();
    _loadLocale().then((_) {
      setState(() {
        selectedLanguage = _locale.languageCode == 'en' ? 'English' : 'Arabic';
      });
    });
    _updateSelectedCountry('us');
    _updateSelectedTheme('Light');
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('selected_language') ?? 'en';
    _locale = Locale(languageCode);
  }

  Future<void> _updateSelectedCountry(String newCountry) async {
    setState(() {
      selectedCountry = newCountry;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_country', selectedCountry);

    widget.onCountryChanged(selectedCountry);
  }

  Future<void> _loadSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCountry = prefs.getString('selected_country') ?? 'us';
    });
  }

  Future<void> _updateSelectedTheme(String newTheme) async {
    setState(() {
      selectedTheme = newTheme;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_theme', selectedTheme);
  }

  Future<void> _loadSelectedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedTheme = prefs.getString('selected_theme') ?? 'Light';
    });
  }

  void _toggleTheme(bool isDarkMode) {
    _updateSelectedTheme(isDarkMode ? 'Dark' : 'Light');
    setState(() {
      selectedTheme = isDarkMode ? 'Dark' : 'Light';
    });
    widget.onThemeChanged(isDarkMode);
  }

  void _changeLanguage() async {
    final languageCode = _locale.languageCode == 'en' ? 'ar' : 'en';
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_language', languageCode);

    setState(() {
      _locale = Locale(languageCode);
      selectedLanguage = _locale.languageCode == 'en' ? 'English' : 'Arabic';
      Intl.defaultLocale = languageCode;
    });
    setState(() {});

    widget.onLanguageChanged(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: selectedTheme == 'Dark' ? ThemeData.dark().brightness : Brightness.light,
        // Add other theme configurations here
      ),
      locale: _locale,
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: AppLocalizations.of(context)?.translate('title') ?? 'Settings',
      home: Scaffold(
        backgroundColor: selectedTheme == 'Dark' ? ThemeData.dark().scaffoldBackgroundColor : Colors.white,

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(Intl.message('Settings', name: 'settingsTitle')),
        ),
        body: Column(
          children: [
            settingItem(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsSelectCountryScreen(
                      currentCountry: selectedCountry,
                      isDarkMode: selectedTheme == 'Dark',
                    ),
                  ),
                );
                if (result != null && result is String) {
                  _updateSelectedCountry(result);
                }
              },

              icon: Icons.language_rounded,
              title: AppLocalizations.of(context)?.translate('country') ??
                  'Country',
              value: selectedCountry,
            ),
            settingItem(
              onTap: () {
                _changeLanguage();
              },
              icon: Icons.language,
              title: AppLocalizations.of(context)?.translate('language') ??
                  'Language',
              value: selectedLanguage,
            ),
            settingItem(
              onTap: () {
                _toggleTheme(selectedTheme == 'Light');
              },
              icon: Icons.color_lens,
              title: AppLocalizations.of(context)?.translate('theme') ??
                  'Theme',
              value: selectedTheme,
            ),
            settingItem(
              onTap: () {
                setState(() {
                  notificationEnabled = !notificationEnabled;
                });
                // Update notification settings accordingly
              },
              icon: Icons.notifications,
              title: AppLocalizations.of(context)?.translate('notification') ??
                  'Notification',
              value: notificationEnabled ? "Enabled" : "Disabled",
            ),
          ],
        ),
      ),
    );
  }

  Widget settingItem({
    required GestureTapCallback onTap,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selectedTheme == 'Dark' ? Colors.transparent : Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 10.sp),
        child: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Row(
            children: [
              Icon(
                icon,
                color: selectedTheme == 'Dark'
                    ? Colors.blueAccent
                    : Colors.blue,
              ),
               SizedBox(width: 5.sp),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: selectedTheme == 'Dark'
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: selectedTheme == 'Dark'
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: selectedTheme == 'Dark'
                    ? Colors.blueAccent
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
