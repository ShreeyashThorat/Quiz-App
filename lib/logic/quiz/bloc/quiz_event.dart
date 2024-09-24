part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartQuiz extends QuizEvent {
  final List<QuestionModel> questions;
  const StartQuiz({required this.questions});

  @override
  List<Object> get props => [questions];
}

class AnswerTheQuestion extends QuizEvent {
  final Quiz answer;
  const AnswerTheQuestion({required this.answer});

  @override
  List<Object> get props => [answer];
}

class AutoSubmit extends QuizEvent {}