part of 'other_single_user_dart_cubit.dart';

abstract class OtherSingleUserDartState extends Equatable {
  const OtherSingleUserDartState();

  @override
  List<Object> get props => [];
}

class OtherSingleUserDartInitial extends OtherSingleUserDartState {}

class OtherSingleUserDartLoading extends OtherSingleUserDartState {}

class OtherSingleUserDartLoaded extends OtherSingleUserDartState {
  final UserEntity otherUser;

  const OtherSingleUserDartLoaded({required this.otherUser});
  @override
  List<Object> get props => [otherUser];
}

class OtherSingleUserDartFailure extends OtherSingleUserDartState {}
