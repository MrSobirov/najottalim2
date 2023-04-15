import 'package:bloc/bloc.dart';
import 'package:dictionary/services/cache_values.dart';
import 'package:dictionary/services/db_service.dart';
import 'package:meta/meta.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit() : super(PdfLoading());

  Future<void> getWords(String type) async {
    emit(PdfLoading());
    switch(type) {
      case "eng_uzb":
        if(CachedModels.engUzbModel.isEmpty) {
          await DBService().getEngUzb("", 1);
        }
        break;
      case "uzb_eng":
        if(CachedModels.uzbEngModel.isEmpty) {
          await DBService().getUzbEng("", 1);
        }
        break;
      case "definition":
        if(CachedModels.definitionModel.isEmpty) {
          await DBService().getDefinition("", 1);
        }
        break;
    }
    emit(PdfLoaded());
  }
}
