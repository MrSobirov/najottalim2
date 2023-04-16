part of 'online_cubit.dart';

@immutable
abstract class OnlineState {}

class OnlineLoading extends OnlineState {}

class OnlineLoaded extends OnlineState {
  final List<WordModel> wordList;
  OnlineLoaded(this.wordList);
}

class OnlineError extends OnlineState {}
