import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/authentication_repo.dart';
import '../../../services/app_exception.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpWithEmailAndPass>((event, emit) async {
      emit(SignUpLoading());
      try {
        await AuthenticationRepo().createUserWithEmailAndPassword(
            event.email, event.pass, event.fnmae, event.lname);
        emit(SignUpSuccessfully());
      } on AppException catch (e) {
        emit(SignUpError(exception: e));
        e.print;
      } catch (e) {
        emit(SignUpError(exception: AppException()));
      }
    });
  }
}

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpWithEmailAndPass extends SignUpEvent {
  final String email;
  final String pass;
  final String fnmae;
  final String lname;
  const SignUpWithEmailAndPass(
      {required this.email,
      required this.pass,
      required this.fnmae,
      required this.lname});
}

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccessfully extends SignUpState {}

class SignUpError extends SignUpState {
  final AppException exception;
  const SignUpError({required this.exception});
}
