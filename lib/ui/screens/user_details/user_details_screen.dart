import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/models/book_model.dart';
import '../../../data/models/user_model.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key, required this.user, required this.heroId})
      : super(key: key);
  final UserModel user;
  final heroId;

  @override
  Widget build(BuildContext context) {
    List<BookModel> books = LayoutCubit.booksStatic.where(
      (element) {
        if (user.books != null) {
          return user.books!.contains(element.id);
        }
        return false;

      },
    ).toList();

    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constrains) => SingleChildScrollView(
          child: SizedBox(
            //  padding: const EdgeInsets.all(5.0),
            height: constrains.maxHeight,
            child: Column(
              children: [
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: double.infinity,
                          height: 170,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: user.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Hero(
                        tag: heroId,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 48,
                            child: CachedNetworkImage(
                              imageUrl: user.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Text(
                      //   'المنشورات+${user.posts.length.toString()}',
                      //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 15,
                      //       ),
                      //   maxLines: 1,
                      //   overflow: TextOverflow.ellipsis,
                      // ),

                      Text(
                        user.bio,
                        style: Theme.of(context).textTheme.caption,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(
                        color: MyColors.defaultPurple,
                      ),
                      ConditionalBuilder(
                        successWidget: (_) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30,),

                            Text('الكتب التي اختارها',style: Theme.of(context).textTheme.titleMedium,),

                            const SizedBox(height: 10,),

                            SizedBox(
                              height: 156,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => bookCard(
                                  context: context,
                                  book: books[index],
                                ),
                                itemCount: books.length,
                                separatorBuilder: (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 8,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        fallbackWidget: (_) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const
                            SizedBox(height: 20,),
                            Image.asset('assets/images/fo.png'),
                            const SizedBox(
                              height: 20,
                            ),
                            Text('لم يختر كتبًا بعد ',style: Theme.of(context).textTheme.titleMedium,),
                          ],
                        ),
                        condition: books.isNotEmpty,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card bookCard({required context, required BookModel book}) {
    return Card(
      elevation: 5,
      child: Container(
        width: 104,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          //color: const Color(0xffd1cde9),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: book.imageLink.toString(),
          errorWidget: (ctx, url, error) => const Icon(Icons.error_outline),
          placeholder: (ctx, url) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
