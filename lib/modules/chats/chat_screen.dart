import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/home_cubit/home_cubit.dart';
import 'package:social_app/shared/cubit/home_cubit/home_states.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var homeCubit = HomeCubit.get(context);
        return ConditionalBuilder(
          condition: homeCubit.allUsers.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(homeCubit.allUsers[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: homeCubit.allUsers.length,
          ),
          fallback: (context) => loading(
            context,
            'loading users...',
          ),
        );
      },
    );
  }

  Widget buildChatItem(UserModel userModel, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            ChatDetailsScreen(
              userModel: userModel,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  userModel.image,
                ),
              ),
              SizedBox(width: 15.0),
              Text(
                userModel.name,
                style: TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
