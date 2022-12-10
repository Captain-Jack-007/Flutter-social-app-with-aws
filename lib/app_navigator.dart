import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:induna/BottomNavView/bottom_nav_bar_view.dart';
import 'package:induna/auth/auth_cubit.dart';
import 'package:induna/auth/auth_navigator.dart';
import 'package:induna/loading_view.dart';
import 'package:induna/profile/profile_view.dart';
import 'package:induna/session/session_cubit.dart';
import 'package:induna/session/session_state.dart';
import 'package:induna/session/session_view.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // Show auth flow
          if (state is Unauthenticated)
            MaterialPage(
              child: BlocProvider(
                create: (context) =>
                    AuthCubit(sessionCubit: context.read<SessionCubit>()),
                child: AuthNavigator(),
              ),
            ),
          // Show session flow
          if (state is Authenticated)
            MaterialPage(child: BottomNavBarView()),
          // Show loading screen
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}