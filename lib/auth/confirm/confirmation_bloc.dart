import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:induna/auth/auth_cubit.dart';
import 'package:induna/auth/auth_repository.dart';
import 'package:induna/auth/form_submission_status.dart';
import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository? authRepo;
  final AuthCubit? authCubit;

  ConfirmationBloc({
    this.authRepo,
    this.authCubit,
  }) : super(ConfirmationState()){
    on<ConfirmationCodeChanged>((event, emit) => emit(state.copyWith(code: event.code)));
    on<ConfirmationSubmitted>((event, emit) async {
      emit(state.copyWith(formStatus: FormSubmitting()));
      try {
        await authRepo!.confirmSignUp(
          username: authCubit!.credentials!.username,
          confirmationCode: state.code,
        );

        emit(state.copyWith(formStatus: SubmissionSuccess()));

        final credentials = authCubit!.credentials;
        final userId = await authRepo!.login(
          username: credentials!.username,
          password: credentials.password,
        );
        credentials.userId = userId;

        authCubit!.launchSession(credentials);
      } catch (e) {
        print(e);
        emit( state.copyWith(formStatus: SubmissionFailed(e as Exception)));
      }
    });
  }
  }