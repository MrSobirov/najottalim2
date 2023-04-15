part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final bool loading;
  final bool loadMore;
  HomeLoaded(this.loading, this.loadMore);
}
