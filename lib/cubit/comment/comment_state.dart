part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoaded extends CommentState {
  final List<CommentEntity> comment;
  @override
  List<Object> get props => [comment];

  const CommentLoaded({required this.comment});
}

class CommentFailure extends CommentState {
  @override
  List<Object> get props => [];
}
