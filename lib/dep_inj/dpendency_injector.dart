import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'export.dart';

// Initializing the service locator
final sl = GetIt.instance;

setupServiceLocator() {
  sl.registerSingleton<PermissionService>(PermissionManager());
}

Future<void> init() async {
  // Registering/ Dependency Injection BLoC / Cubits

  ////////////////////////////////////////////////////////////////////
  ///   Cubits/BLoC Registeration in dependency injector           ///
///////////////////////////////////////////////////////////////////

  sl.registerFactory<CredCubit>(() => CredCubit(
        signInUseCase: sl.call(),
        signUpUseCase: sl.call(),
        // forgotPasswordUseCase: sl.call(),
        getCreateCurrentUserUseCase: sl.call(),
      ));

  // Authentication Cubit
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      isSIgnInUseCase: sl.call(),
      fetchLoggedInUserDataId: sl.call(),
      logoutUserFromFirebaseUseCase: sl.call(),
    ),
  );

  // All Users Cubit
  sl.registerFactory<UserCubit>(() => UserCubit(
        fetchTotalUsersFromFirebaseUseCase: sl.call(),
        updateUserUseCase: sl.call(),
        followUsersUsecase: sl.call(),
        updateUserImgUseCase: sl.call(),
      ));
  // Individual UserCubit
  sl.registerFactory<LoggedInCurrentUserCubit>(() => LoggedInCurrentUserCubit(
        getSingleUserUseCase: sl.call(),
      ));

  // Other Individual User (except CurrentUSer)
  sl.registerFactory<OtherSingleUserDartCubit>(() => OtherSingleUserDartCubit(
        fetchEveryOtherUserUseCase: sl.call(),
      ));

  //Post Cubit
  sl.registerFactory<PostCubit>(() => PostCubit(
        createPostUseCase: sl.call(),
        fetchAndDisplayPostsPostUseCase: sl.call(),
        deletePostUseCase: sl.call(),
        likePostUseCase: sl.call(),
        disLikePostUseCase: sl.call(),
      ));

  // Comment Cubit
  sl.registerFactory<CommentCubit>(() => CommentCubit(
        createCommentUseCase: sl.call(),
        fetchAndReadCommentsUseCase: sl.call(),
        delCommentUseCase: sl.call(),
        likeCommentUseCase: sl.call(),
      ));

  // Current Single User Post Cubit
  sl.registerFactory<CurrentPostCubit>(() => CurrentPostCubit(
        readCurrentUserPostUseCase: sl.call(),
      ));
  // Reply Cubit
  sl.registerFactory<ReplyCubit>(() => ReplyCubit(
        createReplyUseCase: sl.call(),
        deleteReplyUseCase: sl.call(),
        likeReplyUseCase: sl.call(),
        readReplyUseCase: sl.call(),
      ));

// Global CHat Cubit
  sl.registerFactory<GlobalMessageCubit>(() => GlobalMessageCubit(
        sendMessageUsecase: sl.call(),
        getMessageUsecase: sl.call(),
        uploadMessageImageUseCase: sl.call(),
        deleteMessageUseCase: sl.call(),
      ));
  // Download posts/chat image cubit
  sl.registerFactory<DownloadCubitCubit>(() => DownloadCubitCubit(
        downloadFileUsecase: sl.call(),
        downloadPostUsecase: sl.call(),
      ));

  // Usc
  ////////////////////////////////////////////////////////////////////
  ///   Usecases Registeration in dependency injector           ///
///////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<DownloadPostUsecase>(
      () => DownloadPostUsecase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<StorePostToFirebaseUseCase>(
      () => StorePostToFirebaseUseCase(repository: sl.call()));

  sl.registerLazySingleton<StoreGlobalChatImageUseCase>(
      () => StoreGlobalChatImageUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<DownloadFileUsecase>(
      () => DownloadFileUsecase(repositoryInterface: sl.call()));

  sl.registerLazySingleton<GetSignOutUserUseCase>(
      () => GetSignOutUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<StoreImageToFirebaseUseCase>(
      () => StoreImageToFirebaseUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetIsSignedInUsecase>(
      () => GetIsSignedInUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUserUidUseCase>(
      () => GetCurrentUserUidUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetSignUpUserUseCase>(
      () => GetSignUpUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetSignInUserUseCase>(
      () => GetSignInUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserUseCase>(
      () => GetUpdateUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetUpdateUserImgUseCase>(
      () => GetUpdateUserImgUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUseCase>(
      () => GetCreateCurrentUserUseCase(repository: sl.call()));
  sl.registerLazySingleton<UserUseCase>(
      () => UserUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetSingleOtherUserUseCase>(
      () => GetSingleOtherUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<ReadPostPostUseCase>(
      () => ReadPostPostUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<ReadCurrentPostPostUseCase>(
      () => ReadCurrentPostPostUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<LikePostUseCase>(
      () => LikePostUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<DisLikePostUseCase>(
      () => DisLikePostUseCase(repositoryInterface: sl.call()));
  /* sl.registerLazySingleton<UpdatePostUseCase>(
      () => UpdatePostUseCase(repositoryInterface: sl.call())); */
  sl.registerLazySingleton<DeletePostUseCase>(
      () => DeletePostUseCase(repositoryInterface: sl.call()));

  // sl.registerLazySingleton<ForgotPasswordUseCase>(
  //     () => ForgotPasswordUseCase(repository: sl.call()));
  sl.registerLazySingleton<DelCommentUseCase>(
      () => DelCommentUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<CreateCommentUseCase>(
      () => CreateCommentUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<LikeCommentUseCase>(
      () => LikeCommentUseCase(repositoryInterface: sl.call()));

  sl.registerLazySingleton<ReadCommentUseCase>(
      () => ReadCommentUseCase(repositoryInterface: sl.call()));

  sl.registerLazySingleton<CreateReplyUseCase>(
      () => CreateReplyUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<DeleteReplyUseCase>(
      () => DeleteReplyUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<LikeReplyUseCase>(
      () => LikeReplyUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<ReadReplyUseCase>(
      () => ReadReplyUseCase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<FollowUsersUsecase>(
      () => FollowUsersUsecase(repositoryInterface: sl.call()));

  // Messages
  sl.registerLazySingleton<GetMessageUsecase>(
      () => GetMessageUsecase(repositoryInterface: sl.call()));
  sl.registerLazySingleton<SendMessageUsecase>(
      () => SendMessageUsecase(repositoryInterface: sl.call()));
////////////////////////////////////////////////////////////////////
  ///   Repository Registeration in dependency injector           ///
///////////////////////////////////////////////////////////////////
  //Repository

  sl.registerLazySingleton<FirebaseRepositoryInterface>(
      () => FirebaseRepositoryImplementation(remoteDataSource: sl.call()));
  // Global chat repo
  sl.registerLazySingleton<GlobalChatRepoInterface>(
      () => GlobalChatRepoImpl(remoteDataSource: sl.call()));
  // Add Post
  sl.registerLazySingleton<AddPostRepositoryInterface>(
      () => AddPostRepositoryImpl(remoteDataSource: sl.call()));
  // Comment
  sl.registerLazySingleton<CommentAndReplyRepoInterface>(
      () => CommentAndReplyRepoImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<FirebRemoteDataSourceInterface>(
      () => FirebRemoteDataSourceImplementation(
            firestore: sl.call(),
            firebaseAuth: sl.call(),
            storage: sl.call(),
          ));

////////////////////////////////////////////////////////////////////
  ///  Remote Repository Registeration in dependency injector     ///
///////////////////////////////////////////////////////////////////
  //Remote data source
  sl.registerLazySingleton<GlobalChatRemoteDataSourceInterface>(
      () => GlobalChatRemoteDataSourceImpl(
            firestore: sl.call(),
            firebaseAuth: sl.call(),
            storage: sl.call(),
          ));
  sl.registerLazySingleton<AddPostRemoteDataSourceInterface>(
      () => AddPostRemoteDataSourceImpl(
            firestore: sl.call(),
            firebaseAuth: sl.call(),
            storage: sl.call(),
          ));
  sl.registerLazySingleton<CommentReplyRemoteDataSourceInterface>(
      () => CommentReplyRemoteDataSourceImpl(
            firestore: sl.call(),
            firebaseAuth: sl.call(),
            storage: sl.call(),
          ));

  //Local Data source

  //Other dependencies
////////////////////////////////////////////////////////////////////
  ///   Firebase registeration in dependency injector             ///
///////////////////////////////////////////////////////////////////
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => storage);
}
