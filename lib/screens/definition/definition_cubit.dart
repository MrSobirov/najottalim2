import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/db_service.dart';

part 'definition_state.dart';

class DefinitionCubit extends Cubit<DefinitionState> {
  DefinitionCubit() : super(DefinitionLoading());
  
  Future<void> getWords(String word, int page) async {
    bool? hasMore = false;
    if(page == 1) {
      emit(DefinitionLoading());
    } else {
      emit(DefinitionLoaded(true, true));
    }
    hasMore = await DBService().getDefinition(word, page);
    emit(DefinitionLoaded(false, hasMore ?? false));
  }
}
