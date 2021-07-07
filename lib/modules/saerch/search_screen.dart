import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/search_cubit/search_cubit.dart';
import 'package:social_app/shared/cubit/search_cubit/search_states.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var searchCubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultTextForm(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'enter text to search';
                          }
                          return null;
                        },
                        label: 'search',
                        prefix: Icons.search,
                        onSubmit: (value) {
                          searchCubit.search(value);
                        }
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}