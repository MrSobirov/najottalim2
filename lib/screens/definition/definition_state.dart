part of 'definition_cubit.dart';

@immutable
abstract class DefinitionState {}

class DefinitionLoading extends DefinitionState {}

class DefinitionLoaded extends DefinitionState {
  final bool loading;
  final bool loadMore;
  DefinitionLoaded(this.loading, this.loadMore);
}