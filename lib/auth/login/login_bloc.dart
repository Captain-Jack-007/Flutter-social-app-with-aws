import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:induna/auth/auth_credentials.dart';
import 'package:induna/auth/auth_cubit.dart';
import 'package:induna/auth/auth_repository.dart';
import 'package:induna/auth/form_submission_status.dart';
import 'package:induna/auth/login/login_event.dart';
import 'package:induna/auth/login/login_state.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepo;
  final AuthCubit? authCubit;

  LoginBloc({this.authRepo, this.authCubit}) : super(LoginState()) {
    on<LoginUsernameChanged>((event, emit) => emit(state.copyWith(username: event.username)));
    on<LoginPasswordChanged>((event, emit) => emit(state.copyWith(password: event.password)));
    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));

      try {
        final userId = await authRepo!.login(
          username: state.username,
          password: state.password,
        );
        emit(state.copyWith(formStatus: SubmissionSuccess()));

        authCubit!.launchSession(AuthCredentials(
          username: state.username,
          userId: userId,
        ));
      } catch (e) {
        emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    });
  }
}