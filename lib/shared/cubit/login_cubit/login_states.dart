

abstract class LoginStates {}
class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  // final UserModel userModel;
  // LoginSuccessState(this.userModel);
  final String uId;
  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error){
   print(error.toString());
  }
}

class LoginChangePasswordVisibilityState extends LoginStates{}

// class LoginGetUserLoadingState extends LoginStates{}
//
// class LoginGetUserSuccessState extends LoginStates{}
//
// class LoginGetUserErrorState extends LoginStates{
//   final String error;
//   LoginGetUserErrorState(this.error){
//     print(error.toString());
//   }
// }

