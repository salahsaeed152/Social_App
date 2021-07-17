import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/home_cubit/home_cubit.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

void signOut(context) {
  FirebaseAuth.instance.signOut().then((value) {
    CacheHelper.removeData(key: 'uId').then((value) {
      HomeCubit.get(context).currentIndex = 0;
      navigateAndFinish(context, LoginScreen());
    });
  });
}

void printFullText(String text){
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String uId = '';