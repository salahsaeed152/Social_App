
abstract class HomeStates {}

class HomeInitialState extends HomeStates{}

//get user states
class HomeGetUserLoadingState extends HomeStates{}

class HomeGetUserSuccessState extends HomeStates{}

class HomeGetUserErrorState extends HomeStates{
  final String error;

  HomeGetUserErrorState(this.error);
}

//get all users states
class HomeGetAllUsersLoadingState extends HomeStates{}

class HomeGetAllUsersSuccessState extends HomeStates{}

class HomeGetAllUsersErrorState extends HomeStates{
  final String error;

  HomeGetAllUsersErrorState(this.error);
}

//get posts states
class HomeGetPostsLoadingState extends HomeStates{}

class HomeGetPostsSuccessState extends HomeStates{}

class HomeGetPostsErrorState extends HomeStates{
  final String error;
  HomeGetPostsErrorState(this.error);
}

//nav states
class HomeChangeBottomNavState extends HomeStates{}

class HomeNewPostNavState extends HomeStates{}

//pick profile image states
class HomeProfileImagePickedSuccessState extends HomeStates{}

class HomeProfileImagePickedErrorState extends HomeStates{}

//pick cover image states
class HomeCoverImagePickedSuccessState extends HomeStates{}

class HomeCoverImagePickedErrorState extends HomeStates{}

//upload profile image states
class HomeUploadProfileImageSuccessState extends HomeStates{}

class HomeUploadProfileImageErrorState extends HomeStates{}

//upload cover image states
class HomeUploadCoverImageSuccessState extends HomeStates{}

class HomeUploadCoverImageErrorState extends HomeStates{}

//update user data states
class HomeUpdateUserLoadingState extends HomeStates{}

class HomeUpdateUserErrorState extends HomeStates{}

//create post states
class HomeCreatePostLoadingState extends HomeStates{}

class HomeCreatePostSuccessState extends HomeStates{}

class HomeCreatePostErrorState extends HomeStates{}

class HomePostImagePickedSuccessState extends HomeStates{}

class HomePostImagePickedErrorState extends HomeStates{}

class HomeRemovePostImageState extends HomeStates{}

//like post states
class HomeLikePostSuccessState extends HomeStates{}

class HomeLikePostErrorState extends HomeStates{
  final String error;
  HomeLikePostErrorState(this.error);
}

//send message states
class HomeSendMessageSuccessState extends HomeStates{}

class HomeSendMessageErrorState extends HomeStates{
  final String error;

  HomeSendMessageErrorState(this.error);
}

//get all message states
class HomeGetAllMessageSuccessState extends HomeStates{}

class HomeSignOutSuccessState extends HomeStates{}
