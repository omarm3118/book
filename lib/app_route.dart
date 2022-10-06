import 'package:book/data/models/book_model.dart';
import 'package:book/data/repositories/firebase_auth_repository.dart';
import 'package:book/data/repositories/firebase_firestore_repository.dart';
import 'package:book/google_map.dart';
import 'package:book/ui/screens/about_group/about_group_screen.dart';
import 'package:book/ui/screens/book_details/book_details_screen.dart';
import 'package:book/ui/screens/choose_favorite_fields/choose_favorite_fields_screen.dart';
import 'package:book/ui/screens/choose_favorite_fields/controller/choose_favorite_fields_cubit.dart';
import 'package:book/ui/screens/comments/comment_screen.dart';
import 'package:book/ui/screens/course_details/course_details_screen.dart';
import 'package:book/ui/screens/create_group_screen/create_group_screen.dart';
import 'package:book/ui/screens/create_new_post/create_new_post_screen.dart';
import 'package:book/ui/screens/culture_courses/controller/culture_courses_cubit.dart';
import 'package:book/ui/screens/email_verification/email_verification_screen.dart';
import 'package:book/ui/screens/feed/feed_screen.dart';
import 'package:book/ui/screens/log_in/controller/login_cubit.dart';
import 'package:book/ui/screens/log_in/login_screen.dart';
import 'package:book/ui/screens/my_groups/controller/groups_cubit.dart';
import 'package:book/ui/screens/my_groups/my_groups_screen.dart';
import 'package:book/ui/screens/on_boarding/on_boarding_screen.dart';
import 'package:book/ui/screens/polls/polls_screen.dart';
import 'package:book/ui/screens/register/controller/register_cubit.dart';
import 'package:book/ui/screens/show_all_books/show_all_books_screen.dart';
import 'package:book/ui/screens/show_group_users/show_group_users_screen.dart';
import 'package:book/ui/screens/user_details/user_details_screen.dart';
import 'package:book/ui/screens/user_edit_info/user_edit_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/strings.dart';
import 'data/repositories/firebase_storage_repository.dart';
import 'ui/screens/culture_courses/culture_courses_screen.dart';
import 'ui/screens/groups/groups_screen.dart';
import 'ui/screens/home/controller/layout_cubit.dart';
import 'ui/screens/home/layout_screen.dart';
import 'ui/screens/pdf_viewer/pdf_viewer_screen.dart';
import 'ui/screens/register/register_screen.dart';

class AppRoute {
  late final FirebaseAuthRepository _firebaseAuthRepositories;
  late final FirebaseFirestoreRepository _firebaseFirestoreRepository;
  late final FirebaseStorageRepository _firebaseStorageRepository;

  AppRoute()
      : _firebaseAuthRepositories = FirebaseAuthRepository(),
        _firebaseFirestoreRepository = FirebaseFirestoreRepository(),
        _firebaseStorageRepository = FirebaseStorageRepository() {
    // layoutCubit =
    //     LayoutCubit(firebaseFirestoreRepository: _firebaseFirestoreRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //Todo ReCorrect screens
      case loginRoute:
        return _loginScreen();
      case emailVerificationRoute:
        return _emailVerificationScreen();
      case onBoardingRoute:
        return _onBoarding();
      case registerRoute:
        return _registerScreen();
      case chooseFavoriteFieldsRoute:
        return _chooseFavoriteFieldsScreen();
      case homeRoute:
        return _homeScreen();
      case cultureCoursesRoute:
        Map args = settings.arguments as Map;
        return _cultureCoursesScreen(args['context']);
      case courseDetailsRoute:
        Map args = settings.arguments as Map;

        return _courseDetailsScreen(args['courseName'], args['booksId'],
            args['context'], args['bookScreenContext']);
      case groupsRoute:
        Map args = settings.arguments as Map;

        return _groupsScreen(args['context']);
      case pdfViewerRoute:
        Map args = settings.arguments as Map;
        return _pdfViewerScreen(
          args['bookId'],
          args['url'],
          args['bookName'],
          args['context'],
          args['book'],
        );
      case bookDetailsRoute:
        Map args = settings.arguments as Map;
        return _bookDetailsScreen(args['book'], args['context']);
      case showAllBooksRoute:
        Map args = settings.arguments as Map;
        return _showAllBooksRoute(args['books'], args['context']);
      case myGroupsRoute:
        return _myGroupsScreen();
      case createGroupRoute:
        Map args = settings.arguments as Map;
        return _createGroupsScreen(args['context']);
      case aboutGroupRoute:
        Map args = settings.arguments as Map;
        return _aboutGroupScreen(args['group']);
      case feedRoute:
        Map args = settings.arguments as Map;
        return _feedScreen(args['context'], args['group']);
      case newPostRoute:
        Map args = settings.arguments as Map;
        return _newPostScreen(args['context'], args['group']);
      case userDetailsRoute:
        Map args = settings.arguments as Map;
        return _userDetailsScreen(args['user'], args['heroId']);
      case userEditInfoRoute:
        Map args = settings.arguments as Map;
        return _userEditInfoScreen(
            args['user'], args['heroId'], args['context']);
      case pollsRoute:
        Map args = settings.arguments as Map;

        return _pollsScreen(args['context'], args['groupId']);
      case showGroupUsersRoute:
        Map args = settings.arguments as Map;
        return _showGroupUsersScreen(args['users']);
      case commentRoute:
        Map args = settings.arguments as Map;
        return _commentScreen(
          args['context'],
          args['post'],
          args['groupId'],
          args['userId'],
        );
      case googleMap:
        return _googleMap();
    }
    return null;
  }

  Route? _loginScreen() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (BuildContext context) => LoginCubit(
            firebaseAuthRepositories: FirebaseAuthRepository(),
          ),
          //Todo Login
          child: LoginScreen(),
        ),
      ),
    );
  }

  Route? _emailVerificationScreen() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: EmailVerificationScreen(),
      ),
    );
  }

 Route? _googleMap() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: OrderTrackingPage(),
      ),
    );
  }

  Route? _onBoarding() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: OnBoardingScreen(),
      ),
    );
  }

  Route? _registerScreen() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => RegisterCubit(
          firebaseFirestoreRepository: _firebaseFirestoreRepository,
          firebaseAuthRepositories: _firebaseAuthRepositories,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RegisterScreen(),
        ),
      ),
    );
  }

  Route? _homeScreen() {
    return MaterialPageRoute(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) => LayoutCubit(
              firebaseFirestoreRepository: FirebaseFirestoreRepository(),
              firebaseStorageRepository: FirebaseStorageRepository())
            ..getUserInfo()
            ..getBooks()
            ..getAllUsers(),
          child: const LayoutScreen(),
        ),
      ),
    );
  }

  Route? _chooseFavoriteFieldsScreen() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ChooseFavoriteFieldsCubit(
          firebaseFirestoreRepository: _firebaseFirestoreRepository,
        ),
        child: const Directionality(
          textDirection: TextDirection.rtl,
          child: ChooseFavoriteFieldsScreen(),
        ),
      ),
    );
  }

  Route? _cultureCoursesScreen(BuildContext bookScreenContext) {
    return MaterialPageRoute(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) => CultureCoursesCubit(
            firebaseFirestoreRepository: _firebaseFirestoreRepository,
          ),
          child: CultureCoursesScreen(bookScreenContext: bookScreenContext),
        ),
      ),
    );
  }

  Route? _courseDetailsScreen(
    String courseName,
    List booksId,
    context,
    bookScreenContext,
  ) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: MultiBlocProvider(
            providers: [
              BlocProvider<CultureCoursesCubit>.value(
                  value: BlocProvider.of(context)),
              BlocProvider<LayoutCubit>.value(
                  value: BlocProvider.of(bookScreenContext)),
            ],
            child:
                CourseDetailsScreen(courseName: courseName, booksId: booksId)),
      ),
    );
  }

  Route? _groupsScreen(context) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: GroupsScreen(),
        ),
      ),
    );
  }

  Route? _bookDetailsScreen(BookModel book, BuildContext context) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider<LayoutCubit>.value(
          value: BlocProvider.of<LayoutCubit>(context)
            ..getBookRate(bookId: book.id!),
          child: BookDetailsScreen(
            book: book,
          ),
        ),
      ),
    );
  }

  Route? _pdfViewerScreen(
      String bookId, String url, String bookName, context, book) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<LayoutCubit>(context),
          child: PDFViewerScreen(
            url: url,
            bookName: bookName,
            bookId: bookId,
            myBook: book,
          ),
        ),
      ),
    );
  }

  Route? _showAllBooksRoute(List<BookModel> books, context) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<LayoutCubit>(context),
          child: ShowAllBooksScreen(
            books: books,
          ),
        ),
      ),
    );
  }

  Route? _myGroupsScreen() {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) => GroupsCubit(
            firebaseFirestoreRepository: _firebaseFirestoreRepository,
            firebaseStorageRepository: _firebaseStorageRepository,
          ),
          child: const MyGroupsScreen(),
        ),
      ),
    );
  }

  Route? _createGroupsScreen(context) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: CreateGroupScreen(
            user: LayoutCubit.getUser!,
          ),
        ),
      ),
    );
  }

  Route? _aboutGroupScreen(group) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AboutGroupScreen(
          group: group,
        ),
      ),
    );
  }

  Route? _feedScreen(context, group) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: FeedScreen(
            group: group,
          ),
        ),
      ),
    );
  }

  Route? _newPostScreen(context, group) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: CreateNewPost(
            group: group,
          ),
        ),
      ),
    );
  }

  Route? _commentScreen(context, post, groupId, userId) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: CommentScreen(
            post: post,
            groupId: groupId,
            userId: userId,
          ),
        ),
      ),
    );
  }

  Route? _userDetailsScreen(user, commentId) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: UserDetailsScreen(
          user: user,
          heroId: commentId,
        ),
      ),
    );
  }

  Route? _userEditInfoScreen(user, commentId, context) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<LayoutCubit>(context),
          child: UserEditInfoScreen(
            user: user,
            heroId: commentId,
          ),
        ),
      ),
    );
  }

  Route? _pollsScreen(context, String groupId) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: BlocProvider.of<GroupsCubit>(context),
          child: PollsScreen(
            groupId: groupId,
          ),
        ),
      ),
    );
  }

  Route? _showGroupUsersScreen(users) {
    return MaterialPageRoute(
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: ShowGroupUsersScreen(
          users: users,
        ),
      ),
    );
  }
}
