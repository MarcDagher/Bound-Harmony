import 'package:bound_harmony/providers/survey_provider.dart';
import 'package:bound_harmony/reusable%20widgets/navigation_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SurveysScreen extends StatelessWidget {
  const SurveysScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text('Surveys'),
        ),
      ),

      //////// END OF APPBAR
      ///
      ///

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //////// PERSONAL SURVEY - ON CLICK - GO TO QUESTIONS
                Expanded(
                  child: NavigationBox(
                      navigationButtonColor: Colors.white,
                      textAndButtonColor: Theme.of(context).hintColor,
                      title: "Go to Personal Survey",
                      handlePressed: () {
                        context
                            .read<SurveysProvider>()
                            .successSavingPersonalSurveyResponse = false;
                        context.goNamed("Personal Survey");
                      },
                      imagePath: "assets/wallpaper 16.jpg"),
                ),
                const SizedBox(height: 10),

                //////// Couples SURVEY - ON CLICK - GO TO QUESTIONS
                Expanded(
                  child: NavigationBox(
                      overlayColor: const Color.fromARGB(255, 255, 70, 57),
                      navigationButtonColor: Colors.white,
                      textAndButtonColor: Theme.of(context).hintColor,
                      title: "Go to Couples Survey",
                      handlePressed: () {
                        context
                            .read<SurveysProvider>()
                            .successSavingCouplesSurveyResponse = false;
                        context.goNamed("Couples Survey");
                      },
                      imagePath: "assets/wallpaper 17.jpg"),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
