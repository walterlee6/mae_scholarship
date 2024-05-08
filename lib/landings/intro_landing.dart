import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:scholarship_application/components/my_button.dart';
import 'package:scholarship_application/modal/content_modal.dart';
import 'package:scholarship_application/pages/auth_page.dart';
import 'package:scholarship_application/utils/colors.dart';

class IntroLandingPage extends StatefulWidget {
  const IntroLandingPage({super.key});

  @override
  State<IntroLandingPage> createState() => _IntroLandingPageState();
}

class _IntroLandingPageState extends State<IntroLandingPage> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleLogin() {
    if (currentIndex == IntroLandingContent.contents.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
    } else {
      _controller.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: IntroLandingContent.contents.length,
                      onPageChanged: (int index) =>
                          setState(() => currentIndex = index),
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LottieBuilder.asset(
                              IntroLandingContent.contents[index].image,
                              height: 300,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                IntroLandingContent.contents[index].title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                IntroLandingContent.contents[index].description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: 250,
                              child: MyButton(
                                onTap: handleLogin,
                                text: currentIndex ==
                                        IntroLandingContent.contents.length - 1
                                    ? "Continue"
                                    : "Next",
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  IntroLandingContent.contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: currentIndex == index ? 20 : 10,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
      ),
    );
  }
}
