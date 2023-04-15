part of 'pdf_cubit.dart';

@immutable
abstract class PdfState {}

class PdfLoading extends PdfState {}

class PdfLoaded extends PdfState {}
