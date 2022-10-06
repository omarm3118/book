import 'package:book/constants/strings.dart';
import 'package:book/data/models/user_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/dashboard_components.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    LayoutCubit layoutCubit = BlocProvider.of<LayoutCubit>(context);
    if (LayoutCubit.getUser != null) {
      if (LayoutCubit.getUser!.favoriteFields.isNotEmpty) {
        layoutCubit
          ..getUserInfo()
          ..getBooks()
          ..getAllUsers();
      }
    }
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {

          if (LayoutCubit.getUser != null && state is! GetUserSuccessState) {
            if (LayoutCubit.getUser!.favoriteFields.isEmpty) {
              Navigator.pushReplacementNamed(
                context,
                chooseFavoriteFieldsRoute,
              );
            }
          }

      },
      builder: (context, state) {
        UserModel? user = LayoutCubit.getUser;

        return Scaffold(
          body: ConditionalBuilder(
            successWidget: (context) {
              user = LayoutCubit.getUser;

              return layoutCubit.layoutScreens[layoutCubit.navBarIndex];
            },
            fallbackWidget: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            //Todo check if books null of user null
            condition: state is! GetUserLoadingState &&
                state is! GetBooksLoadingState &&
                LayoutCubit.getUser != null &&
                LayoutCubit.getCubit(context).books.isNotEmpty,
          ),
          bottomNavigationBar: navigationBar(layoutCubit, context),
          drawer: LayoutCubit.getUser == null
              ? Container()
              : Drawer(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(defaultRadius)),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              userEditInfoRoute,
                              arguments: {
                                'heroId': user!.uId,
                                'user': user,
                                'context': context,
                              },
                            );
                          },
                          child: Text(
                            'تعديل',
                          ),
                        ),
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          accountName: Text(
                            user!.name,
                            style: TextStyle(color: Colors.black),
                          ),
                          accountEmail: Text(
                            user!.email,
                            style: TextStyle(color: Colors.black),
                          ),
                          currentAccountPicture: Hero(
                            tag: user!.uId,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: CachedNetworkImageProvider(
                                user!.image,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: Container(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              style: TextButton.styleFrom(),
                              onPressed: () {
                                Navigator.pushNamed(context, googleMap);
                              },
                              label: Text(
                              'متاجر الكتب القريبة',
                              ),
                              icon: Icon(Icons.location_on_outlined),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(),
                            onPressed: () {
                              layoutCubit.signOut(context);
                            },
                            child: Text(
                              'تسجيل الخروج',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
