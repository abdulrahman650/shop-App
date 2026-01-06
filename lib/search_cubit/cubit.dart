import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app1/search_cubit/states.dart';

import '../models/search_model.dart';
import '../shared/components/components.dart';
import '../shared/network/end_points.dart';
import '../shared/network/local/dio_helper.dart';



class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String? text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      path: SEARCH,
      data: {
        'text': text,
      },
      token: token,
    ).then((value) {
      model = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((onError) {
      debugPrint(onError.toString());
      emit(SearchErrorState());
    });
  }
}
