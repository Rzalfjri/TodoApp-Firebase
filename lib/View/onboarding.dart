import 'package:flutter/material.dart';
import 'package:flutter_firebase/view/Login.dart';
import 'dart:async'; // Import library untuk Future.delayed

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'title': ' ',
      'subtitle': ' ',
      'image': 'assets/images/Logo-2-[remix].gif',
    }
  ];

  void nextPage() {
    setState(() {
      _currentPage = (_currentPage + 1) % onboardingData.length;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void finishOnboarding() {
    // Implement your logic when the user finishes onboarding.
    // For example, navigate to the login screen.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    // Tambahkan Future.delayed untuk menunggu 5 detik sebelum memanggil finishOnboarding
    Future.delayed(const Duration(seconds: 20), () {
      finishOnboarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: onboardingData[index]['title']!,
            subtitle: onboardingData[index]['subtitle']!,
            image: onboardingData[index]['image']!,
            nextPage: nextPage,
            finishOnboarding: finishOnboarding,
            isLastPage: index == onboardingData.length - 1,
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback nextPage;
  final VoidCallback finishOnboarding;
  final bool isLastPage;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.nextPage,
    required this.finishOnboarding,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
