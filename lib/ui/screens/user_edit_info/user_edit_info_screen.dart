import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:book/ui/widgets/conditional_builder.dart';
import 'package:book/ui/widgets/text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/book_model.dart';
import '../../../data/models/user_model.dart';

class UserEditInfoScreen extends StatelessWidget {
  UserEditInfoScreen({Key? key, required this.user, required this.heroId})
      : super(key: key);
  UserModel user;
  final heroId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final SystemUiOverlayStyle statusBarColor = const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = LayoutCubit.getCubit(context);
    List<BookModel> books = LayoutCubit.booksStatic.where(
      (element) {
        if (user.books != null) {
          return user.books!.contains(element.id);
        }
        return false;
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: statusBarColor,
        actions: [
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.updateUserInfo(
                  name: _nameController.text,
                  bio: _bioController.text,
                );
              }
            },
            child: Text('تأكيد التعديل'),
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<LayoutCubit, LayoutState>(
          builder: (context, state) {
            user = LayoutCubit.getUser!;
            return SingleChildScrollView(
              child: Form(
                key: formKey,
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
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(4)),
                              ),
                              child: Stack(
                                children: [
                                  cubit.coverImage != null
                                      ? Image.file(
                                          cubit.coverImage!,
                                          width: 600,
                                          height: 600,
                                          cacheWidth: 600,
                                          cacheHeight: 600,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: user.cover,
                                          maxHeightDiskCache: 800,
                                          maxWidthDiskCache: 800,
                                    width: 600,
                                    height: 600,
                                          fit: BoxFit.cover,
                                        ),
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    foregroundColor: MyColors.defaultPurple,
                                    child: IconButton(
                                      onPressed: () {
                                        cubit.imagePicker(isCover: true);
                                      },
                                      icon: Icon(
                                        Icons.edit_outlined,
                                      ),
                                    ),
                                  )
                                ],
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
                                backgroundColor: MyColors.defaultIconColor,
                                radius: 48,
                                child: Stack(
                                  children: [
                                    cubit.userImage != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.file(
                                              cubit.userImage!,
                                              width: 600,
                                              height: 600,
                                              cacheWidth: 600,
                                              cacheHeight: 600,
                                              fit: BoxFit.cover,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: CachedNetworkImage(
                                              width: 600,
                                              height: 600,
                                              maxHeightDiskCache: 600,
                                              maxWidthDiskCache: 600,
                                              imageUrl: user.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    CircleAvatar(
                                      backgroundColor: Colors.white.withOpacity(
                                        0.5,
                                      ),
                                      foregroundColor: MyColors.defaultPurple,
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.imagePicker();
                                        },
                                        icon: Icon(Icons.edit_outlined),
                                      ),
                                    ),
                                    if (state is UpdateDataLoadingState)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle),
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DefaultTextFormField(
                            label: 'اسمك',
                            keyboardType: TextInputType.name,
                            validator: (String? name) {
                              if (name == null || name.isEmpty) {
                                return 'يجب أن تكتب اسمًا...';
                              }
                              return null;
                            },
                            preIcon: Icon(
                              Icons.person_outlined,
                            ),
                            textEditingController: _nameController
                              ..text = user.name,
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

                          DefaultTextFormField(
                            label: 'سيرتك',
                            keyboardType: TextInputType.name,
                            validator: (String? bio) {
                              if (bio == null || bio.isEmpty) {
                                return 'يجب أن تكتب سيرتك...';
                              }
                              return null;
                            },
                            preIcon: Icon(
                              Icons.person_outlined,
                            ),
                            textEditingController: _bioController
                              ..text = user.bio,
                          ),
                          ConditionalBuilder(
                            successWidget: (_) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'الكتب التي اختارها',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                                    separatorBuilder:
                                        (BuildContext context, int index) {
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
                                const SizedBox(
                                  height: 20,
                                ),
                                Image.asset('assets/images/fo.png'),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'لم يختر كتبًا بعد ',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
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
            );
          },
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
