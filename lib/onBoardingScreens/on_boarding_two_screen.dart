import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import '../globalUsageValues.dart';
import 'on_boarding_three_screen.dart';

class ScreenOnBoardingTwo extends StatefulWidget {
  const ScreenOnBoardingTwo({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenOnBoardingTwo> createState() => _ScreenOnBoardingTwoState();
}

class _ScreenOnBoardingTwoState extends State<ScreenOnBoardingTwo>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controllerFade;
  late Animation<Offset> animationRight;
  late Animation<Offset> animationLeft;
  late Animation<double> animationFade;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controllerFade = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
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
                  'assets/images/track.svg',
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
                  textData: 'Track your spending',
                  textSize:  20),
            ),
            const CustomSizedBox(
              heightRatio: .02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * .15),
              child: SlideTransition(
                position: animationRight,
                child: CustomText(
                  textColor: commonBlack,
                  textData: 'Keep track of your expenses manually.',
                  textSize: 20,
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
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ScreenOnBoardingThree(),
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
                    textSize:  22,
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
