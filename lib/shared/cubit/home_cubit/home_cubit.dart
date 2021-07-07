import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chat_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/home_cubit/home_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/local/cache_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  UserModel userLoginModel;

  void getUserdata() async {
    emit(HomeGetUserLoadingState());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
      userLoginModel = UserModel.fromJson(value.data());
      emit(HomeGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottom(int index)
  {
    if (index == 1) getAllUsers();
    // if (index == 2) getUserdata();
    // check if index = 2 navigate to AddNewPostScreen else change navBottomScreens
    if (index == 2)
      emit(HomeNewPostNavState());
    else {
      currentIndex = index;
      emit(HomeChangeBottomNavState());
    }
  }

  File profileImage;
  File coverImage;
  File postImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(HomeProfileImagePickedSuccessState());
    } else {
      print('No image selected. ');
      emit(HomeProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(HomeCoverImagePickedSuccessState());
    } else {
      print('No image selected. ');
      emit(HomeCoverImagePickedErrorState());
    }
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(HomePostImagePickedSuccessState());
    } else {
      print('No image selected. ');
      emit(HomePostImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    @required String name,
    @required String bio,
    @required String phone,
  }) {
    emit(HomeUpdateUserLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(HomeUploadProfileImageSuccessState());

        updateUserData(
          name: name,
          bio: bio,
          phone: phone,
          image: value,
        );
      }).catchError((error) {
        print(error.toString());
        emit(HomeUploadProfileImageSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    @required String name,
    @required String bio,
    @required String phone,
  }) {
    emit(HomeUpdateUserLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(HomeUploadCoverImageSuccessState());
        updateUserData(
          name: name,
          bio: bio,
          phone: phone,
          cover: value,
        );
      }).catchError((error) {
        print(error.toString());
        emit(HomeUploadCoverImageSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeUploadProfileImageErrorState());
    });
  }

  void updateUserData({
    @required String name,
    @required String bio,
    @required String phone,
    String cover,
    String image,
  }) async {
    UserModel model = UserModel(
      uId: userLoginModel.uId,
      email: userLoginModel.email,
      image: image ?? userLoginModel.image,
      cover: cover ?? userLoginModel.cover,
      name: name,
      bio: bio,
      phone: phone,
      isEmailVerified: false,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userLoginModel.uId)
        .update(model.toJson())
        .then((value) {
      getUserdata();
    }).catchError((error) {
      print(error.toString());
      emit(HomeUpdateUserErrorState());
    });
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  }) {
    emit(HomeCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
      }).catchError((error) {
        print(error.toString());
        emit(HomeCreatePostErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(HomeCreatePostErrorState());
    });
  }

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  }) async {
    emit(HomeCreatePostLoadingState());

    PostModel model = PostModel(
      uId: userLoginModel.uId,
      name: userLoginModel.name,
      image: userLoginModel.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? ' ',
    );

    await FirebaseFirestore.instance
        .collection('posts')
        .add(model.toJson())
        .then((value) {
      emit(HomeCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(HomeRemovePostImageState());
  }

  List<PostModel> posts = [];
  List<String> postsIds = [];
  List<int> likesNumber = [];
  List<String> likesIds = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          //get post id
          postsIds.add(element.id);
          //get post data
          posts.add(PostModel.fromJson(element.data()));
          //get post likes
          likesNumber.add(value.docs.length);

          value.docs.forEach((element) {
            likesIds.add(element.id);
          });

          // print(likesIds);
        }).catchError((error) {
          print(error.toString());
        });
      });
      emit(HomeGetPostsSuccessState());
    }).catchError((error) {
      emit(HomeGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userLoginModel.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(HomeLikePostSuccessState());
    }).catchError((error) {
      emit(HomeLikePostErrorState(error.toString()));
    });
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId').then((value) {
        navigateAndFinish(context, LoginScreen());
      });
      emit(HomeSignOutSuccessState ());
    });
  }

  List<UserModel> allUsers = [];

  void getAllUsers() {
    emit(HomeGetAllUsersLoadingState());
    if (allUsers.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userLoginModel.uId)
            allUsers.add(UserModel.fromJson(element.data()));
        });
        emit(HomeGetAllUsersSuccessState());
      }).catchError((error) {
        emit(HomeGetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel messageModel = MessageModel(
      senderId: userLoginModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );

    //save message to sender
    FirebaseFirestore.instance
        .collection('users')
        .doc(userLoginModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(HomeSendMessageSuccessState());
    }).catchError((error) {
      emit(HomeSendMessageErrorState(error.toString()));
    });

//save message to receiver
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userLoginModel.uId)
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(HomeSendMessageSuccessState());
    }).catchError((error) {
      emit(HomeSendMessageErrorState(error.toString()));
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userLoginModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(HomeGetAllMessageSuccessState());
    });
  }
}
