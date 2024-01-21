part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {
  @override
  List<Object> get props => [];
}

class PostLoaded extends PostState {
  const PostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
  final List<PostEntity> posts;
}

class PostLoading extends PostState {
  @override
  List<Object> get props => [];
}

class PostFailure extends PostState {
  @override
  List<Object> get props => [];
}
