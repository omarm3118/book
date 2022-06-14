import 'package:book/constants/colors.dart';
import 'package:book/constants/strings.dart';
import 'package:book/data/models/book_model.dart';
import 'package:book/ui/screens/home/controller/layout_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/my_search_delegate.dart';

Card searchBar(context, LayoutCubit cubit, searchController) {
  //Todo right search icon
  return Card(
    surfaceTintColor: Colors.white,
    elevation: 5,
    child: TextFormField(
      autofocus: cubit.isSearch ? true : false,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'ابحث',
        contentPadding:
            const EdgeInsets.only(right: 13, left: 8, bottom: 20, top: 10),
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xffA7A7A7),
            ),
        suffixIcon: SizedBox(
          width: 20,
          height: 20,
          child: Row(
            children: [
              const VerticalDivider(
                indent: 12,
                endIndent: 12,
                width: 16,
                color: Color(0xffA7A7A7),
              ),
              cubit.isSearch
                  ? Flexible(
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.clear)))
                  : SvgPicture.asset(
                      'assets/icon_svgs/icon_search.svg',
                      color: MyColors.defaultIconColor,
                    ),
            ],
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(defaultRadius),
          borderSide: const BorderSide(color: MyColors.defaultPurple),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      onTap: () {
        cubit.openSearch(context);
        // showSearch(context: context, delegate: MySearchDelegate());
      },
      onChanged: (query) {
        cubit.openSearch(context);
      },
    ),
  );
}

Container firstTitle(BuildContext context) {
  return Container(
    alignment: AlignmentDirectional.topEnd,
    child: Text(
      'Popular Tags',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 20,
          ),
    ),
  );
}

Row secondTitle({
  required BuildContext context,
  required List<BookModel> books,
  required String title,
  required bool hasShowMore,
}) {
  return Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 20,
            ),
      ),
      const Spacer(),
      if (hasShowMore)
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, showAllBooksRoute, arguments: {
              'books': books,
              'context': context,
            });
          },
          child: Text(
            'رؤية المزيد',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontSize: 14,
                  color: const Color(0xff808080),
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
    ],
  );
}

Wrap tags(context) {
  return Wrap(
    runSpacing: 6,
    spacing: 4,
    direction: Axis.horizontal,
    //Todo model class
    children: List.generate(
      7,
      (index) => tagItems(
        context,
        isSelected: true,
        label: 'label',
      ),
    ),
  );
}

Container tagItems(context, {required bool isSelected, required String label}) {
  return Container(
    width: 75.0,
    height: 32.0,
    padding: const EdgeInsets.all(3),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isSelected ? MyColors.defaultPurple : const Color(0xffDCDFE3),
      borderRadius: BorderRadius.circular(32.0),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 12,
            color: isSelected ? Colors.white : const Color(0xff808080),
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

SizedBox suggestions(List books, {Axis scrollDirection = Axis.horizontal}) {
  return SizedBox(
    height: 156,
    child: ListView.separated(
      scrollDirection: scrollDirection,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => bookCard(
        context: context,
        book: books[index],
      ),
      itemCount: books.length > 5 ? 5 : books.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 8,
        );
      },
    ),
  );
}

InkWell bookCard({required context, required BookModel book}) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        bookDetailsRoute,
        arguments: {'book': book, 'context': context},
      );
    },
    child: Card(
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
    ),
  );
}

searchList({required List<BookModel> books, required String query}) {
  List queryBooks = query.isEmpty
      ? []
      : books.where((element) {
          return element.name!.toLowerCase().contains(query.toLowerCase()) ||
              element.authorName!.toLowerCase().contains(query.toLowerCase());
        }).toList();
  print(queryBooks);
  return ListView.separated(
    shrinkWrap: true,
    itemBuilder: (context, index) => searchItem(queryBooks[index], context),
    separatorBuilder: (context, index) => const Divider(),
    itemCount: queryBooks.length,
  );
}

searchItem(BookModel book, context) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(
        context,
        bookDetailsRoute,
        arguments: {'book': book, 'context': context},
      );
    },
    child: ListTile(
      leading: Container(
        clipBehavior: Clip.antiAlias,
        width: 48,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Hero(
          tag: book.id.toString(),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: book.imageLink.toString(),
            errorWidget: (ctx, url, error) => const Icon(Icons.error_outline),
            placeholder: (ctx, url) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      title: Text(
        book.name!,
        maxLines: 1,
      ),
      subtitle: Text(
        book.authorName!,
        maxLines: 1,
      ),
    ),
  );
}
