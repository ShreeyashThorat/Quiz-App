import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/async.dart';

import '../../logic/quiz/bloc/quiz_bloc.dart';
import '../../models/question_model.dart';
import '../../models/result_model.dart';
import '../../models/tech_stack_model.dart';
import '../../utils/color_theme.dart';
import '../../widgets/my_button.dart';

class QuizScreen extends StatefulWidget {
  final List<QuestionModel> questions;
  final TechStackModel category;
  const QuizScreen(
      {super.key, required this.questions, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizBloc quizBloc = QuizBloc();
  final int countdownDuration = 900;

  late CountdownTimer countdownTimer;
  int remainingSeconds = 0;
  String answer = "";
  @override
  void initState() {
    super.initState();
    quizBloc.add(StartQuiz(questions: widget.questions));
    countdownTimer = CountdownTimer(
      Duration(seconds: countdownDuration),
      const Duration(seconds: 1),
    );

    countdownTimer.listen((duration) {
      setState(() {
        remainingSeconds = countdownDuration - duration.elapsed.inSeconds;
      });

      if (duration.elapsed.inSeconds >= countdownDuration) {
        quizBloc.add(AutoSubmit());
        log("submit");
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.09,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category.category ?? "",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Text(
                  '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}.${(remainingSeconds % 60).toString().padLeft(2, '0')}',
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.category.category}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                BlocBuilder<QuizBloc, QuizState>(
                  bloc: quizBloc,
                  builder: (context, state) {
                    if (state is QuizInProgressState) {
                      return Text(
                        "Question ${state.questions.index + 1}/20",
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  color: ColorTheme.hintColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Container(
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: BlocBuilder<QuizBloc, QuizState>(
                    bloc: quizBloc,
                    builder: (context, state) {
                      if (state is QuizInProgressState) {
                        return ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04),
                          children: [
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            Text(
                              "${state.questions.myQuestion.question}",
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  height: 1.2,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            ...List.generate(
                                state.questions.myQuestion.options!.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  if (answer.isNotEmpty) {
                                    setState(() {
                                      answer = "";
                                    });
                                  } else {
                                    setState(() {
                                      answer = state
                                          .questions.myQuestion.options![index];
                                    });
                                  }
                                },
                                child: Container(
                                  width: size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.035,
                                      vertical: size.height * 0.017),
                                  margin: EdgeInsets.only(
                                      bottom: size.height * 0.012),
                                  decoration: BoxDecoration(
                                      color: answer ==
                                              state.questions.myQuestion
                                                  .options![index]
                                          ? ColorTheme.primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          width: 0.1,
                                          color: Colors.black.withOpacity(0.1)),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 5,
                                            color:
                                                Colors.black.withOpacity(0.05))
                                      ]),
                                  child: Text(
                                    state.questions.myQuestion.options![index],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: answer ==
                                              state.questions.myQuestion
                                                  .options![index]
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        );
                      }
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      ));
                    },
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.02),
            color: Colors.white,
            child: BlocConsumer<QuizBloc, QuizState>(
              bloc: quizBloc,
              listener: (context, state) {
                if (state is QuizCompletedState) {
                  // Navigator.pushAndRemoveUntil(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ResultPage(
                  //             result: state.result,
                  //           )),
                  //   (route) => route.isFirst,
                  // );
                }
              },
              builder: (context, state) {
                if (state is QuizInProgressState) {
                  return state.index != 19
                      ? Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                              height: 48,
                              child: MyElevatedButton(
                                onPress: () {
                                  if (answer.isNotEmpty) {
                                    Quiz giveAnswer = Quiz(
                                        question:
                                            state.questions.myQuestion.question,
                                        options:
                                            state.questions.myQuestion.options,
                                        givenAnswer: answer,
                                        correctAnswer: state
                                            .questions.myQuestion.correctAnswer,
                                        explanation: state
                                            .questions.myQuestion.explanation,
                                        category: state
                                            .questions.myQuestion.category);
                                    quizBloc.add(
                                        AnswerTheQuestion(answer: giveAnswer));
                                    setState(() {
                                      answer = "";
                                    });
                                  }
                                },
                                buttonColor: answer.isNotEmpty
                                    ? ColorTheme.primaryColor
                                    : ColorTheme.lightGrey,
                                buttonContent: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 48,
                              child: MyOutlineButton(
                                  buttonColor: Colors.white,
                                  elevation: 0,
                                  onPress: () {
                                    if (answer.isEmpty) {
                                      Quiz giveAnswer = Quiz(
                                          question: state
                                              .questions.myQuestion.question,
                                          options: state
                                              .questions.myQuestion.options,
                                          givenAnswer: answer,
                                          correctAnswer: state.questions
                                              .myQuestion.correctAnswer,
                                          explanation: state
                                              .questions.myQuestion.explanation,
                                          category: state
                                              .questions.myQuestion.category);
                                      quizBloc.add(AnswerTheQuestion(
                                          answer: giveAnswer));
                                      setState(() {
                                        answer = "";
                                      });
                                    }
                                  },
                                  borderColor: answer.isNotEmpty
                                      ? ColorTheme.lightGrey
                                      : ColorTheme.primaryColor,
                                  borderWidth: 1,
                                  child: Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: answer.isNotEmpty
                                          ? ColorTheme.lightGrey
                                          : ColorTheme.primaryColor,
                                    ),
                                  )),
                            ))
                          ],
                        )
                      : SizedBox(
                          width: size.width,
                          height: 48,
                          child: MyElevatedButton(
                            onPress: () {
                              Quiz giveAnswer = Quiz(
                                  question: state.questions.myQuestion.question,
                                  options: state.questions.myQuestion.options,
                                  givenAnswer: answer,
                                  correctAnswer:
                                      state.questions.myQuestion.correctAnswer,
                                  explanation:
                                      state.questions.myQuestion.explanation,
                                  category:
                                      state.questions.myQuestion.category);
                              quizBloc
                                  .add(AnswerTheQuestion(answer: giveAnswer));
                              setState(() {
                                answer = "";
                              });
                            },
                            buttonContent: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
