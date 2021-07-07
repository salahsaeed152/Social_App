import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/home_cubit/home_cubit.dart';
import 'package:social_app/shared/cubit/home_cubit/home_states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatelessWidget {
  var globalKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var homeCubit = HomeCubit.get(context);

        var userModel = homeCubit.userLoginModel;

        var profileImage = homeCubit.profileImage;
        var coverImage = homeCubit.coverImage;

        nameController.text = userModel.name;
        bioController.text = userModel.bio;
        phoneController.text = userModel.phone;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                function: () {
                  homeCubit.updateUserData(
                    name: nameController.text,
                    bio: bioController.text,
                    phone: phoneController.text,
                  );
                },
                text: 'Update',
              ),
              SizedBox(width: 15.0),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is HomeUpdateUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is HomeUpdateUserLoadingState)
                    SizedBox(height: 10.0),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage(
                                            userModel.cover,
                                          )
                                        : FileImage(coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  homeCubit.getCoverImage();
                                },
                                icon: CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage(
                                        userModel.image,
                                      )
                                    : FileImage(profileImage),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                homeCubit.getProfileImage();
                              },
                              icon: CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (homeCubit.profileImage != null ||
                      homeCubit.coverImage != null)
                    Row(
                      children: [
                        if (homeCubit.profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    homeCubit.uploadProfileImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  text: 'Upload Profile',
                                ),
                                if(state is HomeUpdateUserLoadingState)
                                  SizedBox(height: 5.0),
                                if(state is HomeUpdateUserLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(width: 8.0),
                        if (homeCubit.coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    homeCubit.uploadCoverImage(
                                      name: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                    );
                                  },
                                  text: 'Upload Cover',
                                ),
                                if(state is HomeUpdateUserLoadingState)
                                SizedBox(height: 5.0),
                                if(state is HomeUpdateUserLoadingState)
                                LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 20.0),
                  defaultTextForm(
                    controller: nameController,
                    type: TextInputType.text,
                    label: 'Name',
                    prefix: IconBroken.User,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'name must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  defaultTextForm(
                    controller: bioController,
                    type: TextInputType.text,
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'bio must not be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  defaultTextForm(
                    controller: phoneController,
                    type: TextInputType.phone,
                    label: 'Phone',
                    prefix: IconBroken.Call,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'phone number must not be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
