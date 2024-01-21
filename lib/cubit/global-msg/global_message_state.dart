part of 'global_message_cubit.dart';

abstract class GlobalMessageState extends Equatable {
  const GlobalMessageState();
}

class GlobalMessageInitial extends GlobalMessageState {
  @override
  List<Object> get props => [];
}

class GlobalMessageLoading extends GlobalMessageState {
  @override
  List<Object> get props => [];
}

class GlobalMessageLoaded extends GlobalMessageState {
  final List<GlobalChatEntity> message;
  const GlobalMessageLoaded({required this.message});
  @override
  List<Object> get props => [message];
}

class GlobalMessageFailure extends GlobalMessageState {
  @override
  List<Object> get props => [];
}
