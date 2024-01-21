part of 'download_cubit_cubit.dart';

abstract class DownloadCubitState extends Equatable {
  const DownloadCubitState();

  @override
  List<Object> get props => [];
}

class DownloadCubitInitial extends DownloadCubitState {}

class DownloadCubitLoading extends DownloadCubitState {
  final double progress;
  const DownloadCubitLoading({required this.progress});

  @override
  List<Object> get props => [progress];
}

class DownloadCubitLoaded extends DownloadCubitState {}

class DownloadCubitFailure extends DownloadCubitState {}
