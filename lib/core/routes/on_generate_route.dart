import 'package:flutter/material.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/req_socio_entities.dart';
import 'package:socio_chat/features/view/pages/auth/login_page.dart';
import 'package:socio_chat/features/view/pages/auth/signup_page.dart';
import 'package:socio_chat/features/view/pages/chat-room/domain/entities/glob_chat_entity.dart';
import 'package:socio_chat/features/view/pages/auth/domain/entities/user-entity/user_entity.dart';
import 'package:socio_chat/features/view/pages/add-post/post_detail_page.dart';
import 'package:socio_chat/features/view/pages/chat-room/global_chat_room.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/display_full_chat_img.dart';
import 'package:socio_chat/features/view/pages/chat-room/widgets/global_chat_view.dart';
import 'package:socio_chat/features/view/pages/comment/cmnt_view.dart';
import 'package:socio_chat/features/view/pages/no-page-found/no_page.dart';
import 'package:socio_chat/features/view/pages/profile/connections/connections_page.dart';
import 'package:socio_chat/features/view/pages/profile/friends/friends_page.dart';
import 'package:socio_chat/features/view/pages/profile/edit_profile.dart';
import 'package:socio_chat/features/view/pages/profile/user_profile_page_view.dart';
import 'package:socio_chat/features/view/pages/profile/widgets/display_full_image.dart';
import 'package:socio_chat/global-widgets/global_widgets.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.editProfileView:
        {
          if (arguments is UserEntity) {
            return routeBuilder(
              EditProfile(
                currUser: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.loginView:
        {
          return routeBuilder(const LoginPage());
        }
      case Routes.signupView:
        {
          return routeBuilder(const SignupPage());
        }

      case Routes.commentView:
        {
          if (arguments is RequiredSocioIds) {
            return routeBuilder(CommentView(
              socioEntity: arguments,
            ));
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.postDetailPage:
        {
          if (arguments is String) {
            return routeBuilder(
              PostDetailPage(
                postId: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.usersProfilePageView:
        {
          if (arguments is String) {
            return routeBuilder(
              UserProfilePageView(
                otherUserId: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.friendsPage:
        {
          if (arguments is UserEntity) {
            return routeBuilder(
              FriendsPage(
                user: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.connectionsPage:
        {
          if (arguments is UserEntity) {
            return routeBuilder(
              ConnectionsPage(
                user: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.displayFullImage:
        {
          if (arguments is UserEntity) {
            return routeBuilder(
              DisplayFullImage(
                currentUser: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.globalChatFullImageView:
        {
          if (arguments is GlobalChatEntity) {
            return routeBuilder(
              DisplayFullChatImage(
                messageEntity: arguments,
              ),
            );
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");
            return routeBuilder(const NoPage());
          }
        }
      case Routes.globalChatRoom:
        {
          return routeBuilder(const GLobalChatRoom());
        }
      case Routes.globalChatView:
        {
          if (arguments is UserEntity) {
            return routeBuilder(GlobalChatView(user: arguments));
          } else {
            NewAppSnackBar.showSnackbar(
                msg: "No scuh page found.", title: "Error!");

            return routeBuilder(const NoPage());
          }
        }

      default:
        {
          routeBuilder(const LoginPage());
        }
    }
    return null;
  }

  static routeBuilder(Widget widget) =>
      MaterialPageRoute(builder: (context) => widget);
}

class Routes {
  static const loginView = "loginView";
  static const signupView = "signupView";
  static const bottomNav = "bottomNav";
  static const addPost = "addPost";
  static const editPost = "editPost";
  static const commentView = "commentView";
  static const editProfileView = "editProfileView";
  static const homeView = "homeView";
  static const profilePage = "profilePage";
  static const postDetailPage = "postDetailPage";
  static const usersProfilePageView = "usersProfilePageView";
  static const friendsPage = "friendsPage";
  static const connectionsPage = "connectionsPage";
  static const displayFullImage = "displayFullImage";
  static const globalChatRoom = "globalChatRoom";
  static const globalChatView = "globalChatView";
  static const globalChatFullImageView = "globalChatFullImageView";
}


 // case Routes.chat: 
      //   {
      //     return routeBuilder(const SignupPage());
      //   }

      // case Routes.bottomNav:
      //   {
      //     return routeBuilder(const BottomNavIndexPage(uid: ""));
      //   }
      // case Routes.addPost:
      //   {
      //     if (arguments is UserEntity) {
      //       return routeBuilder(
      //         AddPostView(
      //           user: arguments,
      //         ),
      //       );
      //     } else {
      //       AppSnackBar.showSnackbar(msg: "No such page found.", title: "");
      //       return routeBuilder(const HomeView());
      //     }
      //   }