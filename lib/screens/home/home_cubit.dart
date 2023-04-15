import 'package:bloc/bloc.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/services/db_service.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  Future<void> getWords(String word, int page) async {
    bool? hasMore = false;
    if(page == 1) {
      emit(HomeLoading());
    } else {
      emit(HomeLoaded(true, true));
    }
    if(CacheKeys.engUzb) {
      hasMore = await DBService().getEngUzb(word, page);
    } else {
      hasMore = await DBService().getUzbEng(word, page);
    }
    emit(HomeLoaded(false, hasMore ?? false));
  }
}
