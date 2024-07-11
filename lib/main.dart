import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news/NewMainScreen.dart';
import 'package:news/app_dio.dart';
import 'package:news/main.dart';
import 'package:news/news_details.dart';
import 'package:news/news_setting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  AppDio.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (pO, pl, p2) {
        return MaterialApp(
          title: 'News App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const NewMainScreen(),
        );
      },
    );
  }
}
class main1 extends StatefulWidget {

  @override
  State<main1> createState() => _main1State();
}

class _main1State extends State<main1> {
  int currentIndex = 0;
  List<Article> articles = [];
  final List<String> titles = [
    'Business',
    'Sports',
    'Health',
    'Science',
    'Technology',
  ];
  late String currentCountry;
  late String currentLanguage;
  ThemeData? currentTheme;

  @override
  void initState() {
    super.initState();
    getNewsByCategory(titles[currentIndex]);
    _loadSettings();
  }
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentCountry = prefs.getString('selected_country') ?? 'us';
      currentTheme = prefs.getString('selected_theme') == 'Dark'
          ? ThemeData.dark()
          : ThemeData.light();
      currentLanguage = prefs.getString('selected_language') == 'ar' ? 'ar' : 'en';
    });
    getNewsByCategory(titles[currentIndex]);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: currentTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text(titles[currentIndex]),
              actions: [
                IconButton(
                  onPressed: () => navToSettingScreen(),
                  icon: Icon(
                    Icons.settings,
                    color: currentTheme?.brightness == Brightness.dark
                        ? Colors.white // White color for dark theme
                        : Colors.black, // Black color for light theme
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              selectedItemColor: currentTheme?.brightness == Brightness.dark ? Colors.white : Colors.blue,
              unselectedItemColor: currentTheme?.brightness == Brightness.dark ? Colors.white54 : Colors.black,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  getNewsByCategory(titles[currentIndex]);
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: "Business",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_baseball_outlined),
                  label: "Sports",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.healing),
                  label: "Health",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.science),
                  label: "Science",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.biotech),
                  label: "Technology",
                ),
              ],
            ),
        ),
    );
  }




void getNewsByCategory(String category) async {
  try {
    final response = await AppDio.get(category: category, currentCountry:currentCountry);

    print("response======>${response.statusCode}");
    print(response.data);

    final news = NewsResponse.fromJson(response.data);
    articles = news.articles;
    setState(() {});
  } catch (e) {
    print("Error fetching data: $e");
    // Handle errors here
  }
}

void navToSettingScreen() async {
  final selectedCountry = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          NewsSettingScreen(
            currentCountry: currentCountry,
            currentLanguage: currentLanguage,
            onCountryChanged: (String newCountry) {
              setState(() {
                currentCountry = newCountry;
                getNewsByCategory(titles[currentIndex]);
              });
            },
            // ignore: non_constant_identifier_names
            onThemeChanged: (bool Theme) {
              setState(() {
                currentTheme =
                Theme ? ThemeData.dark() : ThemeData.light();
              });
            },
            onLanguageChanged: (String newLanguage) {
              setState(() {
                currentLanguage = newLanguage == 'en' ? 'en' : 'ar';
              });
            }, currentTheme: true,
          ),
    ),
  );

  if (selectedCountry != null &&
      selectedCountry is String &&
      selectedCountry != currentCountry) {
    setState(() {
      currentCountry = selectedCountry;
      getNewsByCategory(titles[currentIndex]);
    });
  }
}
}