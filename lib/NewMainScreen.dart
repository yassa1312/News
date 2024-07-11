import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news/app_dio.dart';
import 'package:news/news_details.dart';
import 'package:news/news_setting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  AppDio.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
class NewMainScreen extends StatefulWidget {
  const NewMainScreen({Key? key}) : super(key: key);

  @override
  State<NewMainScreen> createState() => _NewMainScreenState();
}

class _NewMainScreenState extends State<NewMainScreen> {
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
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            Article article = articles[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewsDetailsScreen(url: article.url),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentTheme?.brightness == Brightness.light
                      ? Colors.grey[200]
                      : Colors.black, // Adjust background color based on theme
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                margin: EdgeInsets.all(15.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    article.urlToImage.isEmpty
                        ?  Padding(
                      padding: EdgeInsets.only(top: 10.sp),
                      child: Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            size: 50.sp),
                      ),
                    )
                        : ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage,
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 10.sp,
                        vertical: 15.sp,
                      ),
                      child: Text(article.title,style: TextStyle(fontSize: 18.sp),),
                    ),
                  ],
                ),
              ),
            );
          },
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