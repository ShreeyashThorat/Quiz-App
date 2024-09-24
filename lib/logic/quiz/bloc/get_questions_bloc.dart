import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/repositories/quiz_repo.dart';
import 'package:quiz_app/services/app_exception.dart';

class GetQuestionsBloc extends Bloc<GetQuestionsEvent, GetQuestionsState> {
  GetQuestionsBloc() : super(GetQuestionsInitial()) {
    on<GetQuizQuestions>((event, emit) async {
      emit(GetQuestionsLoading());
      try {
        final questions = await QuizRepo().getQuations(event.category);
        emit(GetQuestionsLoaded(questions: questions));
      } on AppException catch (e) {
        emit(GetQuestionsError(exception: e));
        e.print;
      } catch (e) {
        log("Get Levels ${e.toString()}");
        emit(GetQuestionsError(exception: AppException()));
      }
    });
  }
}

// Events
class GetQuestionsEvent extends Equatable {
  const GetQuestionsEvent();

  @override
  List<Object> get props => [];
}

class GetQuizQuestions extends GetQuestionsEvent {
  final String category;
  const GetQuizQuestions({required this.category});
}

class GetQuestionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetQuestionsInitial extends GetQuestionsState {}

class GetQuestionsLoading extends GetQuestionsState {}

class GetQuestionsLoaded extends GetQuestionsState {
  final List<QuestionModel> questions;
  GetQuestionsLoaded({required this.questions});

  @override
  List<Object> get props => [questions];
}

class GetQuestionsError extends GetQuestionsState {
  final AppException exception;
  GetQuestionsError({required this.exception});

  @override
  List<Object> get props => [exception];
}
