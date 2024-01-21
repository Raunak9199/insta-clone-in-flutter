part of 'current_post_cubit.dart';

abstract class CurrentPostState extends Equatable {
  const CurrentPostState();

  @override
  List<Object> get props => [];
}

class CurrentPostInitial extends CurrentPostState {
  @override
  List<Object> get props => [];
}

class CurrentPostLoading extends CurrentPostState {
  @override
  List<Object> get props => [];
}

class CurrentPostLoaded extends CurrentPostState {
  final PostEntity postEntity;

  const CurrentPostLoaded({required this.postEntity});
  @override
  List<Object> get props => [postEntity];
}

class CurrentPostFailure extends CurrentPostState {
  @override
  List<Object> get props => [];
}
