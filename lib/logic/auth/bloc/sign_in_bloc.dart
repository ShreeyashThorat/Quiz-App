import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/authentication_repo.dart';
import '../../../services/app_exception.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInWithEmailAndPass>((event, emit) async {
      emit(SignInLoading());
      try {
        await AuthenticationRepo()
            .loginWithEmailAndPassword(event.email, event.pass);
        emit(SignInSuccessfully());
      } on AppException catch (e) {
        emit(SignInError(exception: e));
        e.print;
      } catch (e) {
        emit(SignInError(exception: AppException()));
      }
    });
    on<SignInWithGoogle>((event, emit) async {
      emit(SignInLoading());
      try {
        await AuthenticationRepo().signInWithGoogle();
        emit(SignInSuccessfully());
      } on AppException catch (e) {
        emit(SignInError(exception: e));
        e.print;
      } catch (e) {
        emit(SignInError(exception: AppException()));
      }
    });
  }
}

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithEmailAndPass extends SignInEvent {
  final String email;
  final String pass;
  const SignInWithEmailAndPass({required this.email, required this.pass});
}

class SignInWithGoogle extends SignInEvent {}

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccessfully extends SignInState {}

class SignInError extends SignInState {
  final AppException exception;
  const SignInError({required this.exception});
}
