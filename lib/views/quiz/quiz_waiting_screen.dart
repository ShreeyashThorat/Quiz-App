import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/models/tech_stack_model.dart';
import 'package:quiz_app/views/quiz/quiz_screen.dart';
import 'package:quiz_app/widgets/loading.dart';

import '../../logic/quiz/bloc/get_questions_bloc.dart';
import '../../utils/color_theme.dart';
import '../bottom nav/bottom_nav.dart';

class QuizWaitingScreen extends StatefulWidget {
  final TechStackModel stack;
  const QuizWaitingScreen({super.key, required this.stack});

  @override
  State<QuizWaitingScreen> createState() => _QuizWaitingScreenState();
}

class _QuizWaitingScreenState extends State<QuizWaitingScreen> {
  final GetQuestionsBloc getQuestionsBloc = GetQuestionsBloc();
  Timer? timer;
  int countdownStart = 5;

  @override
  void initState() {
    getQuestionsBloc.add(GetQuizQuestions(category: widget.stack.id!));
    super.initState();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdownStart == 0) {
        setState(() {
          // isWait = true;
          timer.cancel();
        });
      } else {
        setState(() {
          countdownStart--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.primaryColor,
      body: BlocConsumer<GetQuestionsBloc, GetQuestionsState>(
        bloc: getQuestionsBloc,
        listener: (context, state) {
          if (state is GetQuestionsError) {
            Loading.showSnackBar(context, "Failed to get questions");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const BottomNavScreen()));
          } else if (state is GetQuestionsLoaded) {
            startCountdown();
            Timer(const Duration(seconds: 5), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizScreen(
                          questions: state.questions,
                          category: widget.stack,
                        )),
                (route) => route.isFirst,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is GetQuestionsLoading || state is GetQuestionsInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (state is GetQuestionsError) {
            return Center(
              child: Text(
                state.exception.message ?? "Something went wrong",
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (state is GetQuestionsLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Aptitude Test',
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: '\n${widget.stack.category}',
                            style: TextStyle(
                                fontSize: 26,
                                color: ColorTheme.lightGrey,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Let’s Begin in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minHeight: size.height * 0.16,
                          minWidth: size.height * 0.16),
                      padding: EdgeInsets.all(size.height * 0.017),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: ColorTheme.lightGrey),
                      child: Text(
                        "$countdownStart",
                        style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                            color: ColorTheme.primaryColor),
                      ),
                    )
                  ],
                ),
                const Text(
                  "15 minutes | 20 Questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
