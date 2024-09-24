import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../models/question_model.dart';
import '../../../models/result_model.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  List<Quiz> quiz = [];
  List<MyQuestionModel> questions = [];
  int marks = 0;
  QuizBloc() : super(QuizInitial()) {
    on<StartQuiz>((event, emit) {
      for (int i = 0; i < event.questions.length; i++) {
        questions
            .add(MyQuestionModel(index: i, myQuestion: event.questions[i]));
      }

      final question = questions.elementAt(0);
      log(questions.toString());
      emit(QuizInProgressState(questions: question, index: 0));
    });
    on<AnswerTheQuestion>((event, emit) async {
      final state = this.state;
      if (state is QuizInProgressState) {
        if (state.index != 19) {
          if (event.answer.givenAnswer!.isEmpty) {
            questions.removeAt(state.index);
            questions.add(state.questions);
            final question = questions.elementAt(state.index);
            emit(QuizInProgressState(questions: question, index: state.index));
          } else {
            final int currentIndex = state.index + 1;
            quiz.add(event.answer);

            final question = questions.elementAt(currentIndex);
            if (state.questions.myQuestion.correctAnswer ==
                event.answer.givenAnswer) {
              marks = ++marks;
            }
            emit(QuizInProgressState(questions: question, index: currentIndex));
          }
        } else {
          emit(SubmitingQuiz());
          quiz.add(event.answer);
          if (state.questions.myQuestion.correctAnswer ==
              event.answer.givenAnswer) {
            marks = ++marks;
          }
          final formattedDateFormat = DateFormat('d MMM, y');
          final date = formattedDateFormat.format(DateTime.now());
          List<Quiz> submittedQuiz = [];
          List<MyQuestionModel> theQuestion = [...questions];
          theQuestion.sort((a, b) => a.index.compareTo(b.index));
          for (MyQuestionModel element in theQuestion) {
            String? questionToFind = element.myQuestion.question;
            Quiz matchingQuiz =
                quiz.firstWhere((q) => q.question == questionToFind);

            submittedQuiz.add(matchingQuiz);
          }
          ResultModel result = ResultModel(
              totalQuestions: 20,
              score: marks,
              quiz: submittedQuiz,
              date: date);
          final myScore = marks / 20 / 0.01;
          if (myScore >= 75) {
            // await LearningRepo().submitResult(result);
            // await UserDB.saveResults([result]);
            log(result.toJson().toString());
            emit(QuizCompletedState(result: result));
          } else {
            log(result.toJson().toString());
            emit(QuizCompletedState(result: result));
          }
        }
      }
    });

    on<AutoSubmit>((event, emit) async {
      emit(SubmitingQuiz());
      Set<String?> questionsInQuiz = quiz.map((quiz) => quiz.question).toSet();

      List<Quiz> unansweredQuestions = questions
          .where((question) =>
              !questionsInQuiz.contains(question.myQuestion.question))
          .map((question) {
        return Quiz(
          question: question.myQuestion.question,
          options: question.myQuestion.options,
          givenAnswer: "",
          correctAnswer: question.myQuestion.correctAnswer,
          explanation: question.myQuestion.explanation, category: question.myQuestion.category,
        );
      }).toList();

      List<Quiz> finalQuizList = [...quiz, ...unansweredQuestions];
      final formattedDateFormat = DateFormat('d MMM, y');
      final date = formattedDateFormat.format(DateTime.now());
      ResultModel result = ResultModel(
          totalQuestions: 20,
          score: marks,
          quiz: finalQuizList,
          date: date);
      final myScore = marks / 20 / 0.01;
      if (myScore >= 75) {
        // await LearningRepo().submitResult(result);
        // await UserDB.saveResults([result]);
        log(result.toJson().toString());
        emit(QuizCompletedState(result: result));
      } else {
        log(result.toJson().toString());
        emit(QuizCompletedState(result: result));
      }
      log(finalQuizList.toString());
    });
  }
}

class MyQuestionModel {
  final int index;
  final QuestionModel myQuestion;
  MyQuestionModel({required this.index, required this.myQuestion});
}
