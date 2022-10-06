import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/strings.dart';
import '../../../../data/models/user_model.dart';
import '../controller/layout_cubit.dart';

class SavedPostsScreen extends StatelessWidget {
  SavedPostsScreen({Key? key}) : super(key: key);
  var fitting = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LayoutCubit, LayoutState>(
          builder: (context, state) {
            return FutureBuilder(
              future: LayoutCubit.getCubit(context).getSavedPosts(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (ConnectionState.done == snapshot.connectionState) {
                  return ConditionalBuilder(
                    successWidget: (_) => SingleChildScrollView(
                      child: Column(children: [
                        ...List.generate(
                          snapshot.data.length,
                          (index) => Container(
                            width: double.infinity,
                            child: Card(
                              elevation: 3,
                              margin: EdgeInsets.all(defaultPadding),
                              surfaceTintColor: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: 4),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: userInfo(
                                              context,
                                              LayoutCubit.allUsers!.firstWhere(
                                                (element) =>
                                                    element.uId ==
                                                    snapshot.data[index]
                                                        ['userId'],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 19,
                                          ),
                                          if (snapshot.data[index]['text'] !=
                                                  null &&
                                              snapshot.data[index]['text'] !=
                                                  '')
                                            postText(context,
                                                snapshot.data[index]['text']),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                          if (snapshot.data[index]['image'] !=
                                                  null &&
                                              snapshot.data[index]['image'] !=
                                                  '')
                                            StatefulBuilder(
                                              builder: (
                                                BuildContext context,
                                                void Function(void Function())
                                                    setState,
                                              ) {
                                                return postImage(
                                                    snapshot.data[index]
                                                        ['image'],
                                                    setState);
                                              },
                                            ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ]),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 25,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: MyColors.defaultPurple,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(8)),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icon_svgs/icon_bookmark_outlined.svg',
                                        color: Colors.white,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    fallbackWidget: (BuildContext) => Center(
                      child: Text(' لا منشورات محفوظة بعد'),
                    ),
                    condition:
                        (snapshot.data != null && snapshot.data.isNotEmpty),
                  );
                }
                if (ConnectionState.waiting == snapshot.connectionState) ;
                {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          },
        ),
      ),
    );
  }

  GestureDetector postImage(
    String image,
    setState,
  ) {
    return GestureDetector(
      onTap: () {
        fitting = fitting == BoxFit.contain ? BoxFit.cover : BoxFit.contain;
        setState(() {});
      },
      child: Container(
        width: fitting == BoxFit.contain ? 347 : 347,
        height: fitting == BoxFit.contain ? 193 : 193,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          border: Border.all(strokeAlign: StrokeAlign.outside, width: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: fitting,
        ),
      ),
    );
  }

  Text postText(context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: const Color(0xff808080),
            fontWeight: FontWeight.w400,
          ),
    );
  }

  GestureDetector userInfo(
    context,
    UserModel user,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          userDetailsRoute,
          arguments: {
            'user': user,
            'heroId': user.uId,
          },
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey.withOpacity(0.5),
            backgroundImage: CachedNetworkImageProvider(
              user.image,
            ),
          ),
          Text(
            user.name,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20),
          ),
        ],
      ),
    );
    // return ListTile(
    //   onTap: () {
    //     Navigator.pushNamed(
    //       context,
    //       userDetailsRoute,
    //       arguments: {
    //         'user': user,
    //         'heroId': user.uId,
    //       },
    //     );
    //   },
    //   contentPadding: EdgeInsets.zero,
    //   leading: CircleAvatar(
    //     radius: 25,
    //     backgroundColor: Colors.grey.withOpacity(0.5),
    //     backgroundImage: CachedNetworkImageProvider(
    //       user.image,
    //     ),
    //   ),
    //   title: Text(
    //     user.name,
    //     style: Theme.of(context).textTheme.titleSmall!.copyWith(
    //           color: Colors.black,
    //           fontWeight: FontWeight.w400,
    //         ),
    //   ),
    // );
  }
}
