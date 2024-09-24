part of 'quiz_bloc.dart';

sealed class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

final class QuizInitial extends QuizState {}

class QuizInProgressState extends QuizState {
  final MyQuestionModel questions;
  final int index;
  const QuizInProgressState({required this.questions, required this.index});
  @override
  List<Object> get props => [questions];
}

class SubmitingQuiz extends QuizState {}

class QuizCompletedState extends QuizState {
  final ResultModel result;
  const QuizCompletedState({required this.result});
  @override
  List<Object> get props => [result];
}