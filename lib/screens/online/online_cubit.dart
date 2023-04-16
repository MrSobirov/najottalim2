import 'package:bloc/bloc.dart';
import 'package:dictionary/models/word_model.dart';
import 'package:dictionary/repositories/word_repository.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/utils/my_widgets.dart';
import 'package:meta/meta.dart';

part 'online_state.dart';

class OnlineCubit extends Cubit<OnlineState> {
  OnlineCubit() : super(OnlineLoaded([]));

  Future<void> searchWordOnline(String word) async {
    if(!(await CacheKeys.hasInternet())) {
      MyWidgets().showToast("No internet");
      return;
    }
    if(word.isEmpty) {
      emit(OnlineLoaded([]));
      return;
    }
    emit(OnlineLoading());
    List<WordModel>? result = await WordRepo().wordRepo(word);
    if(result != null) {
      emit(OnlineLoaded(result));
    } else {
      emit(OnlineError());
    }
  }
}
