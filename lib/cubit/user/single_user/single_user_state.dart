part of 'single_user_cubit.dart';

abstract class LoggedInuserState extends Equatable {
  const LoggedInuserState();
}

class LoggedInUserInitial extends LoggedInuserState {
  @override
  List<Object> get props => [];
}

class LoggedInUserLoading extends LoggedInuserState {
  @override
  List<Object> get props => [];
}

class LoggedInUserLoaded extends LoggedInuserState {
  final UserEntity user;

  const LoggedInUserLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

class LoggedInUserFailure extends LoggedInuserState {
  @override
  List<Object> get props => [];
}
