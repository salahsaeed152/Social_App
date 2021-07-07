import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/search_model.dart';
import 'package:social_app/shared/cubit/search_cubit/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel searchModel;

  void search(String text) {
    emit(SearchLoadingState());

  }


}