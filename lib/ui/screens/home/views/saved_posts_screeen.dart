import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                              surfaceTintColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    userInfo(
                                      context,
                                      LayoutCubit.allUsers!.firstWhere(
                                        (element) =>
                                            element.uId ==
                                            snapshot.data[index]['userId'],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 19,
                                    ),
                                    if (snapshot.data[index]['text'] != null &&
                                        snapshot.data[index]['text'] != '')
                                      postText(context,
                                          snapshot.data[index]['text']),
                                    const SizedBox(
                                      height: 11,
                                    ),
                                    if (snapshot.data[index]['image'] != null &&
                                        snapshot.data[index]['image'] != '')
                                      postImage(snapshot.data[index]['image']),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
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
  ) {
    return GestureDetector(
      onTap: () {
        fitting = fitting == BoxFit.contain ? BoxFit.cover : BoxFit.contain;
      },
      child: Container(
        width: fitting == BoxFit.contain ? 347 : 347,
        height: fitting == BoxFit.contain ? 193 : 193,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
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

  ListTile userInfo(
    context,
    UserModel user,
  ) {
    return ListTile(
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
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey.withOpacity(0.5),
        backgroundImage: CachedNetworkImageProvider(
          user.image,
        ),
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}
