import 'package:social_app/models/user_model.dart';

abstract class RegisterStates {}
class RegisterInitialState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  final String error;
  RegisterErrorState(this.error){
    print(error.toString());
  }
}

class CreateUserSuccessState extends RegisterStates{
  final UserModel userModel;
  CreateUserSuccessState(this.userModel);
}

class CreateUserErrorState extends RegisterStates{
  final String error;
  CreateUserErrorState(this.error){
    print(error.toString());
  }
}

class RegisterChangePasswordVisibilityState extends RegisterStates{}

