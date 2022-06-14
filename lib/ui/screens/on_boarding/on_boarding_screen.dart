import 'package:book/constants/strings.dart';
import 'package:book/data/web_services/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [
                Container(
                  color: Color(0xff6a246a),
                  child: Image.asset(
                    'assets/images/onboardingfirst.png',
                  ),
                ),
                Container(
                  color: Color(0xff6a246a),
                  child: Image.asset(
                    'assets/images/onboardingsecond.png',
                  ),
                ),
                Container(
                  color: Color(0xff6a246a),
                  child: Image.asset(
                    'assets/images/onboardingthird.png',
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment(0.0, -0.9),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff6a246a),
        onPressed: () {
          (!onLastPage)
              ? _controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                )
              : CacheHelper.setBool(key: 'onBoarding', value: false)
                  .then((value) => Navigator.pushReplacementNamed(
                        context,
                        loginRoute,
                      ));
        },
        child: onLastPage ? Icon(Icons.check) : Icon(Icons.navigate_next),
      ),
    );
  }
}
