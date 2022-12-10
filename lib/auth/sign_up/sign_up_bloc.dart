import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:induna/auth/auth_cubit.dart';
import 'package:induna/auth/auth_repository.dart';
import 'package:induna/auth/form_submission_status.dart';
import 'package:induna/auth/sign_up/sign_up_event.dart';
import 'package:induna/auth/sign_up/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository? authRepo;
  final AuthCubit? authCubit;

  SignUpBloc({this.authRepo, this.authCubit}) : super(SignUpState()){
    on<SignUpUsernameChanged>((event, emit) => emit(state.copyWith(username: event.username)));
    on<SignUpEmailChanged>((event, emit) => emit(state.copyWith(password: event.email)));
    on<SignUpPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password)));
    on<SignUpSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await authRepo!.signUp(
      username: state.username,
      email: state.email,
      password: state.password,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      authCubit!.showConfirmSignUp(
      username: state.username,
      email: state.email,
      password: state.password,
      );
      } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    });
  }
}