import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cubit/register_cubit/register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void registerUser({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) async {
    emit(RegisterLoadingState());

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        uId: value.user.uid,
        name: name,
        email: email,
        phone: phone,
      );
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
    @required String name,
    @required String email,
    @required String phone,
    @required String uId,
  }) async {
    UserModel model = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      isEmailVerified: false,
      image: 'https://image.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg',
      cover: 'https://image.freepik.com/free-photo/businessman-holding-tablet-writing-invisible-screen-with-stylus-social-media-cover_53876-98531.jpg',
      bio: 'write your bio ...',
    );
    await FirebaseFirestore.instance.collection('users').doc(uId).set(model.toJson()).then((value) {
      print('sent to fire store');
      emit(CreateUserSuccessState(model));
    }).catchError((error) {
      emit(CreateUserErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}
