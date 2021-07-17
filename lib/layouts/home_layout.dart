import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/home_cubit/home_cubit.dart';
import 'package:social_app/shared/cubit/home_cubit/home_states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // if(state is HomeNewPostNavState) {
        //   navigateTo(context, NewPostScreen());
        // }
      },
      builder: (context, state) {
        HomeCubit homeCubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              homeCubit.titles[homeCubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: Icon(IconBroken.Notification),
                onPressed: ()
                {

                },
              ),
            ],
          ),
          body: homeCubit.bottomScreens[homeCubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeCubit.currentIndex,
            onTap: (index) {
              homeCubit.changeBottom(index, context);
              print(homeCubit.currentIndex);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Paper_Upload),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Location),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Setting),
                label: 'Sittings',
              ),
            ],
          ),
        );
      },
    );
  }
}
