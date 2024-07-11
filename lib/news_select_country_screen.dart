import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewsSelectCountryScreen extends StatefulWidget {
  final String currentCountry;
  final bool isDarkMode; // Add a bool for theme mode

  const NewsSelectCountryScreen({
    Key? key,
    required this.currentCountry,
    required this.isDarkMode, // Receive the theme mode
  }) : super(key: key);

  @override
  State<NewsSelectCountryScreen> createState() => _NewsSelectCountryScreenState();
}

class _NewsSelectCountryScreenState extends State<NewsSelectCountryScreen> {
  String selectedCountry = 'us';
  final List<String> countries = ['us', 'eg', 'cn', 'id'];

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.currentCountry;
  }

  Future<void> _saveCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_country', country);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch theme data from widget property
    final themeData = widget.isDarkMode ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: themeData, // Apply theme data
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Country'),
        ),
        body: ListView.separated(
          itemCount: countries.length,
          separatorBuilder: (context, index) => Container(
            width: double.infinity, // Expand the divider to full width
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Divider(
              thickness: 2,
              color: Colors.grey[800],
            ),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                countries[index],
                style: TextStyle(fontSize: 18.sp),
              ),
              onTap: () async {
                setState(() {
                  selectedCountry = countries[index];
                });
                await _saveCountry(selectedCountry);
                Navigator.pop(context, selectedCountry);
              },
            );
          },
        ),
      ),
    );
  }
}
