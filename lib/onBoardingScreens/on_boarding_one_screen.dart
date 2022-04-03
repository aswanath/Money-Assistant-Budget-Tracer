import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/main.dart';
import '../globalUsageValues.dart';
import 'on_boarding_two_screen.dart';

class ScreenOnboardingOne extends StatefulWidget {
  const ScreenOnboardingOne({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenOnboardingOne> createState() => _ScreenOnBoardingOneState();
}

class _ScreenOnBoardingOneState extends State<ScreenOnboardingOne>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controllerFade;
  late Animation<Offset> animationRight;
  late Animation<Offset> animationLeft;
  late Animation<double> animationFade;

  @override
  void initState() {
    prefs.setBool('notification', true);
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controllerFade = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 000));
    animationRight =
        Tween(begin: const Offset(1.0, 0.0), end: const Offset(0, 0.0))
            .animate(controller);
    animationLeft =
        Tween(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
            .animate(controller);
    animationFade = Tween(begin: 0.0, end: 1.0).animate(controllerFade);
    controller.forward();
    controllerFade.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSizedBox(
              heightRatio: .25,
            ),
            Center(
              child: SlideTransition(
                position: animationRight,
                child: SvgPicture.asset(
                  'assets/images/all.svg',
                  height: deviceHeight * .23,
                ),
              ),
            ),
            const CustomSizedBox(
              heightRatio: .06,
            ),
            SlideTransition(
              position: animationLeft,
              child: CustomText(
                  textColor: secondaryPurple,
                  textData: 'All your finance in one place',
                  textSize: 20),
            ),
            const CustomSizedBox(
              heightRatio: .02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * .1),
              child: SlideTransition(
                position: animationRight,
                child: CustomText(
                  textColor: commonBlack,
                  textData: 'See all of your financial dealings in one place',
                  textSize:  20,
                  textAlignment: TextAlign.center,
                ),
              ),
            ),
            const CustomSizedBox(
              heightRatio: .1,
            ),
            FadeTransition(
              opacity: animationFade,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor: MaterialStateProperty.all(secondaryPurple),
                ),
                onPressed: () async {
                  await prefs.setBool('isViewed', true);
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ScreenOnBoardingTwo(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * .12,
                      vertical: deviceHeight * .01),
                  child: CustomText(
                    textColor: commonWhite,
                    textData: 'NEXT',
                    textSize: 22,
                    textWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
