import 'package:equatable/equatable.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/entities/post_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/domain/usecases/download_posts_usecase.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/usecases/download_file_usecase.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/widgets.dart';

part 'download_cubit_state.dart';

class DownloadCubitCubit extends Cubit<DownloadCubitState> {
  DownloadCubitCubit({
    required this.downloadFileUsecase,
    required this.downloadPostUsecase,
  }) : super(DownloadCubitInitial());
  final DownloadFileUsecase downloadFileUsecase;
  final DownloadPostUsecase downloadPostUsecase;
  Future<void> downloadChatImage(
      {required GlobalChatEntity message, required String imageName}) async {
    emit(const DownloadCubitLoading(progress: 0));
    try {
      await downloadFileUsecase.call(message, imageName, (double progress) {
        emit(DownloadCubitLoading(progress: progress));
      });
      emit(DownloadCubitLoaded());
    } on SocketException catch (_) {
      emit(DownloadCubitFailure());
    } catch (_) {
      emit(DownloadCubitFailure());
    }
  }

  // download post
  Future<void> downloadPostImage(
      {required PostEntity postEntity, required String imageName}) async {
    emit(const DownloadCubitLoading(progress: 0));
    try {
      await downloadPostUsecase.call(postEntity, imageName, (double progress) {
        emit(DownloadCubitLoading(progress: progress));
      });
      emit(DownloadCubitLoaded());
    } on SocketException catch (_) {
      emit(DownloadCubitFailure());
    } catch (_) {
      emit(DownloadCubitFailure());
    }
  }
}
