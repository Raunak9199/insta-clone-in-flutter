part of 'cred_cubit.dart';

abstract class CredState extends Equatable {
  const CredState();

  @override
  List<Object> get props => [];
}

class CredInitial extends CredState {}

class CredentialSuccess extends CredState {
  // @override
  // List<Object> get props => [];
}

class CredentialFailure extends CredState {
  // @override
  // List<Object> get props => [];
}

class CredentialLoading extends CredState {
  // @override
  // List<Object> get props => [];
}
