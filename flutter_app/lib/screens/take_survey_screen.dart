import 'package:bound_harmony/reusables/button.dart';
import 'package:bound_harmony/reusables/navigation_bar.dart';
import 'package:flutter/material.dart';

class TakeSurveyScreen extends StatelessWidget {
  const TakeSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> questions = {
      "What's your name?": ["option1", "option2", "option3"],
      "What's your name?1": ["option1", "option2", "option3"],
      "What's your name?2": ["option1", "option2", "option3"],
      "What's your name?3": ["option1", "option2", "option3"],
      "What's your name?4": ["option1", "option2", "option3"],
      "What's your name?5": ["option1", "option2", "option3"],
      "What's your name?44": ["option1", "option2", "option3"],
      "What's your name?52": ["option1", "option2", "option3"],
      "What's your name?246": ["option1", "option2", "option3"],
      "What's your name?235": ["option1", "option2", "option3"],
      "What's your name?354": ["option1", "option2", "option3"],
      "What's your name?346": ["option1", "option2", "option3"],
      "What's your name?654": ["option1", "option2", "option3"],
      "What's your name?265": ["option1", "option2", "option3"],
      "What's your name?526": ["option1", "option2", "option3"],
      "What's your name?2465": ["option1", "option2", "option3"],
    };

    return Scaffold(
      // floatingActionButton: Button(text: 'Submit', handlePressed: () {}),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final entry = questions.entries.elementAt(index);
                  return Column(
                    children: [
                      buildQuestion(entry.key, Theme.of(context).hintColor),
                      for (String option in entry.value) buildOption(option),
                    ],
                  );
                },
              ),
            ),
            Button(text: 'Submit', handlePressed: () {})
          ],
        ),
      ),
      bottomNavigationBar: MyNavigationBar(),
    );
  }

  Widget buildQuestion(question, textColor) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            question,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget buildOption(option) {
    return Container(
      child: Text(
        option,
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
