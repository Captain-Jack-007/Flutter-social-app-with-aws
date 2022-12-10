import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:induna/auth/form_submission_status.dart';
import 'package:induna/data_repository.dart';
import 'package:induna/image_url_cache.dart';
import 'package:induna/models/User.dart';
import 'package:induna/profile/profile_event.dart';
import 'package:induna/profile/profile_state.dart';

import '../storage_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DataRepository dataRepo;
  final StorageRepository storageRepo;
  final _picker = ImagePicker();

  ProfileBloc({
    required this.dataRepo,
    required this.storageRepo,
    required User user,
    required bool isCurrentUser,
  }) : super(ProfileState(user: user, isCurrentUser: isCurrentUser)) {
    ImageUrlCache.instance
        .getUrl(user.avatarKey!)
        .then((url) => add(ProvideImagePath(avatarPath: url)));

    on<ChangeAvatarRequest>((event, emit) => emit(state.copyWith(imageSourceActionSheetIsVisible: true)));
    on<OpenImagePicker>((event, emit) async {
      emit(state.copyWith(imageSourceActionSheetIsVisible: false));
      final pickedImage = await _picker.getImage(source: event.imageSource);
      if (pickedImage == null) return;

      final imageKey = await storageRepo.uploadFile(File(pickedImage.path));

      final updatedUser = state.user.copyWith(avatarKey: imageKey);

      final results = await Future.wait([
        dataRepo.updateUser(updatedUser),
        storageRepo.getUrlForFile(imageKey),
      ]);
      emit(state.copyWith(avatarPath: results.last as String));
    });
    on<ProvideImagePath>((event, emit) => emit(state.copyWith(avatarPath: event.avatarPath!)));

    on<ProfileDescriptionChanged>((event, emit) => emit(state.copyWith(userDescription: event.description!)));

    on<SaveProfileChanges>((event, emit) async { emit(state.copyWith(formStatus: FormSubmitting()));
    final updatedUser =
    state.user.copyWith(description: state.userDescription);

    try {
      await dataRepo.updateUser(updatedUser);
      emit (state.copyWith(formStatus: SubmissionSuccess()));
    } catch (e) {
      emit (state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
    });
  }
}